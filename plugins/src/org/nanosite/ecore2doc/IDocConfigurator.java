package org.nanosite.ecore2doc;

import java.util.List;

public interface IDocConfigurator {

	class Section {
		public int order;
		public String rootClassname;
		public String headline;
		public String introduction;
		
		public Section (int order, String rootClass, String headline, String introduction) {
			this.order = order;
			this.rootClassname = rootClass;
			this.headline = headline;
			this.introduction = introduction;
		}
	}

	String cfgPrefix();
	String cfgSectionTag();
	String cfgClassTag();

	List<Section> cfgSections();
	
	/*
	 * If the ecore model is backed by a DSL, the syntax of the DSL might 
	 * put additional restrictions on the ecore semantics. This hook can
	 * be used to check if a feature which is optional due to the ecore model
	 * is non-optional (i.e., mandatory) due to the DSL's syntax. 
	 */
	boolean isReallyOptional(String clazz, String feature);
}
