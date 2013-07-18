package org.nanosite.ecore2doc

import com.google.inject.Inject
import java.util.List
import java.util.Map
import java.util.Set
import java.util.Stack
import org.eclipse.emf.codegen.ecore.genmodel.GenClass
import org.eclipse.emf.codegen.ecore.genmodel.GenClassifier
import org.eclipse.emf.codegen.ecore.genmodel.GenDataType
import org.eclipse.emf.codegen.ecore.genmodel.GenEnum
import org.eclipse.emf.codegen.ecore.genmodel.GenFeature
import org.eclipse.emf.codegen.ecore.genmodel.GenModel
import org.eclipse.emf.ecore.EClassifier
import org.eclipse.emf.ecore.util.EcoreUtil
import org.nanosite.ecore2doc.IDocConfigurator$Section

class Ecore2DocGenerator {
	
	@Inject extension IDocFormatter
	@Inject extension IDocConfigurator
	//@Inject extension IEObjectDocumentationProvider

	Set<GenClassifier> toBeDocumented	
	Set<String> missingClassDocumentation = newHashSet
	Set<String> missingFeatureDocumentation = newHashSet
	
	def generateXdocFromGenModel (GenModel it) {
		missingClassDocumentation.clear
		missingFeatureDocumentation.clear
	
		val pkg = allGenPackagesWithClassifiers.get(0)
		
		// compute GenClasses we have to document
		val allGenClasses = pkg.genClasses

		// get one GenClass object for the class name of each documentation section
		val List<GenClass> sections = newArrayList
		val Map<Section,GenClass> sectionRoots = newHashMap
		for(section : cfgSections) {
			val classname = section.rootClassname
			val gc = allGenClasses.findFirst[ecoreClass.name==classname]
			if (gc==null)
				println("Error: unknown GenClass " + classname + "!")
			else {
				sections.add(gc)
				sectionRoots.put(section, gc)
			}
		}

		// compute one set of GenClasses for each documentation section
		var Set<GenClassifier> visited = newHashSet
		var Map<String,List<GenClassifier>> results = newHashMap
		for(gc : sections) {
			sections.toSet.remove(gc)
			val Set<GenClassifier> exclude = newHashSet
			exclude.addAll(visited)
			exclude.addAll(sections.filter[it!=gc].toSet)
			val used = pkg.getGenClassifiers.getUsedGenClasses(gc, exclude)
			results.put(gc.name, used)
			visited.addAll(used)
			//used.print(gc.name)
		}
		toBeDocumented = visited


		// actually generate documentation for each section
		for(section : sectionRoots.keySet.sortBy[order]) {
			// generate documentation for this section
			val classname = section.rootClassname
			println('''«cfgSectionTag»:«cfgPrefix»Section_«classname»[«section.headline»]''')
			println('')
			println(section.introduction)
			println('')
			for(gc : results.get(classname))
				println(gc.generateClassifierDoc)
		}

		for(d : missingClassDocumentation)
			println("WARNING: missing class documentation for " + d)
		for(d : missingFeatureDocumentation)
			println("WARNING: missing feature documentation for " + d)
		val issues = missingClassDocumentation.size + missingFeatureDocumentation.size
		if (issues>0)
			println("Open issues: " + issues +".")
	}

//	def private print (List<GenClass> items, String tag) {
//		print(tag + ": ")
//		for(c : items) {
//			print(" " + c.name)
//		}
//		println(" (" + items.size + ").")
//	}
	
	def private getUsedGenClasses (List<GenClassifier> all, GenClass root, Set<GenClassifier> exclude) {
		val Stack<GenClassifier> worklist = new Stack
		worklist.push(root)
		val Set<GenClassifier> visited = newHashSet
		val List<GenClassifier> result = newLinkedList
		val allClasses = all.filter(typeof(GenClass))
		while (! worklist.empty) {
			val c = worklist.pop
			if (! (visited.contains(c) || exclude.contains(c))) {
				visited.add(c)
				
				// only select items which are in 'all' list (i.e., those in the current package)
				if (all.contains(c))
					result.add(c)
				
				// add classes needed by this class to worklist
				switch (c) {
					GenClass: {
						for(f : c.genFeatures)
							if (f.typeGenClassifier!=null)
								worklist.push(f.typeGenClassifier)
								
						for(derived : allClasses.filter[baseGenClasses.contains(c)])
							worklist.push(derived)					
					}
				}
			} 
		}
		result
	}


	def private dispatch generateClassifierDoc (GenClass it) '''
		«cfgClassTag»:«ecoreClass.genSectionRef»[Class «ecoreClass.name»«IF ecoreClass.^abstract» (abstract)«ENDIF»]

		«getDocumentation»
		«IF hasFeatures»
		«startItems»
			«generateAllFeatures(it, 0)»
		«endItems»
		«ENDIF»
	'''

	def private dispatch generateClassifierDoc (GenDataType it) '''
		«cfgClassTag»:«ecoreClassifier.genSectionRef»[DataType «ecoreClassifier.name»]
	'''

	def private dispatch generateClassifierDoc (GenEnum it) '''
		«cfgClassTag»:«ecoreClassifier.genSectionRef»[Enum «ecoreClassifier.name»]

		«getDocumentation»
		
		This enum consists of the following literals:  
		«FOR e : it.genEnumLiterals SEPARATOR ', '»e[«e.enumLiteralInstanceConstantName»]«ENDFOR».
	'''


	def private boolean hasFeatures (GenClass it) {
		if (! genFeatures.empty)
			return true
			
		for(bc : baseGenClasses)
			if (bc.hasFeatures)
				return true
				
		return false
	}


	def private generateAllFeatures (GenClass it, GenClass leaf, int level) '''
		«FOR bc : baseGenClasses»
		«bc.generateAllFeatures(leaf, level+1)»
		«ENDFOR»
		«generateLocalFeatures(leaf, level>0)»
	'''
	
	def private generateLocalFeatures (GenClass it, GenClass leaf, boolean withBasename) '''
		«FOR f : genFeatures»
			«itemStart»«f.genFeature(leaf)»: «f.documentation»
				«IF withBasename» Inherited from base class «genGenClassifierRef».«ENDIF»
			«itemEnd»
		«ENDFOR»
	'''

	def private genFeature (GenFeature it, GenClass clazz) {
		val ef = ecoreFeature
		val basetype =
			if (typeGenClass!=null)
				typeGenClass.genGenClassifierRef
			else
				ef.EType.name
		var ret = 
			if (ef.many)
				'List<' + basetype + '>'
			else
				basetype
				
		ret = ret + ' ' + ef.name.emphasize
		if ((!ef.required) && (!ef.many)) {
			// lists are never optional (they just may contain 0 elements)
			if (isReallyOptional(clazz.name, ef.name))
				ret = ret + ' (optional)'
		}
		ret
	}

	def private getDocumentation (GenClassifier it) {
		val doc = EcoreUtil::getDocumentation(ecoreClassifier)
		if (doc!=null && ! doc.empty) {
			var ret = doc
			for(gc : toBeDocumented) {
				val link = gc.genGenClassifierRef
				ret = ret.replace(gc.name + ' ', link + ' ')
				ret = ret.replace(gc.name + 's', link + 's')
			}
			ret
		} else {
			missingClassDocumentation.add(ecoreClassifier.name)
			''
		}
	}
		
	def private getDocumentation (GenFeature it) {
		if (propertyDescription!=null) {
			var doc = propertyDescription.escapeString
			val last = doc.length-1
			if (doc.substring(last, last+1) != '.')
				doc = doc + '.'
			doc.toFirstUpper
		} else {
			val ec = (eContainer as GenClass).ecoreClass.name
			missingFeatureDocumentation.add(ec + "." + ecoreFeature.name)
			''
		}
	}


	def private genGenClassifierRef (GenClassifier it) {
		if (toBeDocumented.contains(it))
			referTo(ecoreClassifier.genSectionRef, ecoreClassifier.name)
		else
			ecoreClassifier.name
	}

	def private String genSectionRef (EClassifier classifier) {
		cfgPrefix + classifier.name
	}
	
}

