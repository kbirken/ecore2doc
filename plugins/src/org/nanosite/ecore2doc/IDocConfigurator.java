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
}
