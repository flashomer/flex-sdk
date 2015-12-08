package spark.collections {
    import mx.core.FlexGlobals;
    import mx.core.UIComponent;
    import mx.styles.AdvancedStyleClient;
    import mx.styles.IAdvancedStyleClient;
    import mx.styles.StyleProtoChain;
    import mx.utils.NameUtil;

    public class AdvancedStyleClient_ extends AdvancedStyleClient {
        private var _styleClient:IAdvancedStyleClient;

        public function AdvancedStyleClient_(styleClient:IAdvancedStyleClient)
        {
            super();
            _styleClient = styleClient;
        }

        override public function initialized(document:Object, id:String):void
        {
            var uiComponent:UIComponent = document as UIComponent;

            if (uiComponent == null)
                uiComponent = FlexGlobals.topLevelApplication as UIComponent;

            this.id = id;

            this.moduleFactory = uiComponent.moduleFactory;

            uiComponent.addStyleClient(_styleClient);
        }

        override protected function setDeferredStyles():void
        {
            if (!deferredSetStyles)
                return;

            for (var styleProp:String in deferredSetStyles)
            {
                StyleProtoChain.setStyle(_styleClient, styleProp, deferredSetStyles[styleProp]);
            }

            deferredSetStyles = null;
        }

        override public function setStyle(styleProp:String, newValue:*):void
        {
            _styleClient.setStyle(styleProp, newValue);
        }

        public function setStyleImpl(styleProp:String, newValue:*):void
        {
            // If there is no module factory then defer the set
            // style until a module factory is set.
            if (moduleFactory)
            {
                StyleProtoChain.setStyle(_styleClient, styleProp, newValue);
            }
            else
            {
                if (!deferredSetStyles)
                    deferredSetStyles = {};

                deferredSetStyles[styleProp] = newValue;
            }
        }

        override public function getStyle(styleProp:String):*
        {
            return _styleClient.getStyle(styleProp);
        }

        public function getStyleImpl(styleProp:String):*
        {
            return super.getStyle(styleProp);
        }

        override public function matchesCSSType(cssType:String):Boolean
        {
            return StyleProtoChain.matchesCSSType(_styleClient, cssType);
        }

        override public function get className():String
        {
            return NameUtil.getUnqualifiedClassName(_styleClient);
        }

        override public function getClassStyleDeclarations():Array
        {
            return StyleProtoChain.getClassStyleDeclarations(_styleClient);
        }

        override public function regenerateStyleCache(recursive:Boolean):void
        {
            StyleProtoChain.initProtoChain(_styleClient);
        }

        override public function styleChanged(styleProp:String):void
        {
            _styleClient.styleChanged(styleProp);
        }

        public function styleChangedImpl(styleProp:String):void
        {
            super.styleChanged(styleProp);
        }
    }
}
