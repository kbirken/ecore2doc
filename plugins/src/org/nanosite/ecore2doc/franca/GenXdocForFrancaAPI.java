package org.nanosite.ecore2doc.franca;

import org.eclipse.emf.codegen.ecore.genmodel.GenModel;
import org.eclipse.emf.common.util.URI;
import org.eclipse.emf.ecore.plugin.EcorePlugin;
import org.eclipse.xtext.util.Modules2;
import org.franca.core.dsl.FrancaIDLRuntimeModule;
import org.franca.core.franca.FrancaPackage;
import org.junit.Test;
import org.nanosite.ecore2doc.Ecore2DocGenerator;
import org.nanosite.ecore2doc.GenModelLoader;

import com.google.inject.Guice;
import com.google.inject.Injector;

public class GenXdocForFrancaAPI {

	private final String myFrancaSources = "file://D:/pgm/franca/EclipseLabs/franca";
			
    @Test
	public void test() {
        EcorePlugin.getEPackageNsURIToGenModelLocationMap(false).put(FrancaPackage.eNS_URI,
        	URI.createURI(myFrancaSources + "/plugins/org.franca.core/model/Franca.genmodel"));
        
    	Injector injector = Guice.createInjector(Modules2.mixin(new FrancaIDLRuntimeModule(), new FrancaAPI2XdocModule()));

    	GenModelLoader loader = new GenModelLoader();
        GenModel model = loader.getGenModel(FrancaPackage.eNS_URI);
        Ecore2DocGenerator gen = injector.getInstance(Ecore2DocGenerator.class);
        gen.generateXdocFromGenModel(model);
	}

}
