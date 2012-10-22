package org.nanosite.ecore2doc.franca;

import org.nanosite.ecore2doc.IDocConfigurator;
import org.nanosite.ecore2doc.IDocFormatter;
import org.nanosite.ecore2doc.xdoc.XdocFormatter;
import org.nanosite.ecore2doc.franca.FrancaDocConfigurator;

import com.google.inject.AbstractModule;

public class FrancaAPI2XdocModule extends AbstractModule {

    @Override
	protected void configure() {
		bind(IDocFormatter.class).to(XdocFormatter.class);
		bind(IDocConfigurator.class).to(FrancaDocConfigurator.class);
	}
}
