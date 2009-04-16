#define ppVarGetSet(name, var, type) \
	[Bindable] \
	public function get name ():type \
	{ \
		return var; \
	} \
	public function set name (inVar:type):void \
	{ \
		var = inVar; \
	}
	
#define ppVarGet(name, var, type) \
	public function get name():type \
	{ \
		return var; \
	} 
	
#define ppVarSet(name, var, type) \
	public function set name(inVar:type):void \
	{ \
		var = inVar; \
	} 
	
#define ppCreatePaddedHtmlText(name, padding) \
	var name:com.htmlFilter.text = new com.htmlFilter.text(); \
	{ \
		name.selectable=true; \
		name.condenseWhite=false; \
		name.percentWidth = 100; \
		name.setStyle("paddingLeft", 10); \
		name.setStyle("paddingRight", 10); \
		name.setStyle("paddingTop", padding); \
		name.setStyle("paddingBottom", padding); \
	} 

#define ppCreateRowBox(name) \
	var name:mx.containers.HBox = new mx.containers.HBox(); \
	{ \
		name.percentWidth = 100; \
		name.setStyle("paddingTop", 0); \
		name.setStyle("paddingBottom", 0); \
	}
	
#define ppCreateHtmlText(name) \
	ppCreatePaddedHtmlText(name, 0)
	
#define ppCreateDefaultStyle(name) \
	name = new StyleSheet; \
 \
	var h1:Object = new Object(); \
	h1.fontFamily = "Verdana"; \
	h1.fontWeight = "bold"; \
	h1.color = "#000000"; \
	h1.fontSize = 20; \
	h1.leading = 10; \
 \
	var h2:Object = new Object(); \
	h2.fontFamily = "Verdana"; \
	h2.fontWeight = "bold"; \
	h2.color = "#333333"; \
	h2.fontSize = 16; \
	h2.leading = 4; \
 \
	var a:Object = new Object(); \
	a.fontFamily = "Verdana"; \
	a.fontSize = 12; \
	a.color = "#0066FF"; \
	a.textDecoration = "underline"; \
 \
	var para:Object = new Object(); \
	para.fontFamily = "Verdana"; \
	para.fontSize = 12; \
	para.paddingLeft = 10; \
	para.paddingTop = 5; \
	para.paddingBottom = 10; \
 \
	var htmlTableCaption:Object = new Object(); \
	htmlTableCaption.fontFamily = "Verdana"; \
	htmlTableCaption.fontSize = 12; \
	htmlTableCaption.borderStyle = "none"; \
	htmlTableCaption.textAlign = "center"; \
	htmlTableCaption.fontWeight = "bold"; \
 \
	name.setStyle("h1", h1); \
	name.setStyle("h2", h2); \
	name.setStyle("p", para); \
	name.setStyle("a", a); \
	name.setStyle("htmlCelltext", para); \
	name.setStyle("htmlTableCaption", htmlTableCaption); \
	name.setStyle("listItems", para); \
	
	
