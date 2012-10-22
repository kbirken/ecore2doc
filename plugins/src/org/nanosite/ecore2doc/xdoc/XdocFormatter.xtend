package org.nanosite.ecore2doc.xdoc

import org.nanosite.ecore2doc.IDocFormatter

class XdocFormatter implements IDocFormatter {
	
	override emphasize (String txt) '''e[«txt»]'''

	override startItems() '''
		ul[
	'''

	override itemStart() '''item['''
	override itemEnd() ''']'''
	
	override endItems() '''
		]
	'''


	override refTarget(String ref, String txt) {
		throw new UnsupportedOperationException("Auto-generated function stub")
	}
	
	override referTo(String ref, String txt) '''ref:«ref»[«txt»]'''

	override escapeString (String txt) {
		txt
			.replace('[', '\\[')
			.replace(']', '\\]')
	}
}
