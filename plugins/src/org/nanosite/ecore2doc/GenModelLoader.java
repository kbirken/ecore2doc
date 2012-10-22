package org.nanosite.ecore2doc;

import java.io.IOException;
import java.util.Map;

import org.eclipse.emf.codegen.ecore.genmodel.GenModel;
import org.eclipse.emf.codegen.ecore.genmodel.GenModelPackage;
import org.eclipse.emf.common.util.URI;
import org.eclipse.emf.ecore.EPackage;
import org.eclipse.emf.ecore.EcorePackage;
import org.eclipse.emf.ecore.plugin.EcorePlugin;
import org.eclipse.emf.ecore.resource.Resource;
import org.eclipse.emf.ecore.resource.ResourceSet;
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl;
import org.eclipse.emf.ecore.xmi.impl.EcoreResourceFactoryImpl;

public class GenModelLoader {

	public GenModel getGenModel (String nsURI) {
        EPackage.Registry.INSTANCE.put(GenModelPackage.eNS_URI, GenModelPackage.eINSTANCE);

		Map<String, URI> map = EcorePlugin.getEPackageNsURIToGenModelLocationMap();
		if (map == null) {
			System.err.println("Cannot load EcorePlugin NsURI to GenModel location map");
			return null;
		}

		URI genModelLocation = (URI)map.get(nsURI);
		//System.out.println("model location = " + genModelLocation);

		ResourceSet rs = new ResourceSetImpl();
		rs.getResourceFactoryRegistry().getExtensionToFactoryMap().put("ecore", new EcoreResourceFactoryImpl());
		rs.getResourceFactoryRegistry().getExtensionToFactoryMap().put("genmodel", new EcoreResourceFactoryImpl());
		rs.getPackageRegistry().put(EcorePackage.eNS_URI, EcorePackage.eINSTANCE);
		rs.getPackageRegistry().put(GenModelPackage.eNS_URI, GenModelPackage.eINSTANCE);
		
        Resource resource = rs.createResource(genModelLocation);
        try {
            resource.load(null);
        } catch (IOException e) {
            throw new RuntimeException(e);
        }

		return (GenModel)resource.getContents().get(0);
    }
    

}
