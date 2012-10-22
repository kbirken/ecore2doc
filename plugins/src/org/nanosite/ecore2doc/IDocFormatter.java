package org.nanosite.ecore2doc;

public interface IDocFormatter {

	String emphasize (String txt);

	String startItems();
	String itemStart();
	String itemEnd();
	String endItems();
	
	String refTarget (String ref, String txt);
	String referTo (String ref, String txt);
	
	String escapeString (String txt);
}
