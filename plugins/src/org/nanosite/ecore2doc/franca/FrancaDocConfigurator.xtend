package org.nanosite.ecore2doc.franca

import org.nanosite.ecore2doc.IDocConfigurator
import org.nanosite.ecore2doc.IDocConfigurator$Section
import java.util.List

class FrancaDocConfigurator implements IDocConfigurator {
	override String cfgPrefix()     '''FrancaModelAPIReference_'''
	override String cfgSectionTag() '''section'''
	override String cfgClassTag()   '''section2'''
	
	override List<Section> cfgSections() {
		val List<Section> ret = newArrayList

		ret.add(new Section(2, 'FType', 'API for Franca types',
			'''This section describes all API classes needed for Franca type definitions.
			See the section ref:FIDL_Types[Data types] in the Franca User Guide for
			detailed information about defining types with Franca.'''
		))

		ret.add(new Section(1, 'FModel', 'API for Franca models, interfaces and type collections',
			'''This section describes the FModel class, which is the root class for each Franca model.
			It also describes FTypeCollection as well as FInterface and all its elements (e.g.,
			attributes, methods and broadcasts.
			See the section ref:FIDL_Interface[Interface definition] in the Franca User Guide for
			detailed information about interfaces.'''
		))

		ret.add(new Section(3, 'FContract', 'API for Franca contracts',
			'''This section describes all API classes needed for Franca interface contracts. 
			The root class of the interface contract subtree is FContract.
			See the section ref:FIDL_Contracts[Contracts] in the Franca User Guide for
			detailed information about contracts.'''
		))

		ret.add(new Section(4, 'FAnnotationBlock', 'API for Franca structured comments',
			'''This section describes the API classes representing structured comments. 
			Note that it is a special feature of Franca that comments are available at all
			in the model. This is not the case for unstructured comments, which basically
			will be removed by the parser when creating the abstract syntax tree.
			See the section ref:FIDL_CommentsStructured[Structured comments] in the
			Franca User Guide for detailed information about structured comments.'''
		))

		ret
	}
}
