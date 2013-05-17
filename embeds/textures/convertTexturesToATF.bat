png2atf -c -i bully1024_2x2.png -o bully1024_2x2.atf
png2atf -c -i toddlers1024-2x2.png -o toddlers1024-2x2.atf

:: ==========================================
:: Ref: http://away3d.com/tutorials/Introduction_to_ATF_Textures and docs
:: ==========================================
:: Example to convert png to ATF
:: ./png2atf -c d -r -q 0 -f 0 -i YOUR_PROJECT_PATH/asset/floor/floor_specular.png -o YOUR_PROJECT_PATH/asset/floor/floor_specular.atf
:: arguments info:
:: -c d -r (creates a block based compression texture. d means it’ll be dxt1/dxt5 and works only on windows and osx. If we take this ‘d’ flag out texture will work on every platform)
:: -q and -f are for quality adjustment. Basically higher the number more compression.
::
:: -c = block based compression no alpha
:: -i = input
:: -o = output
:: -n = disable auto mip maps
:: -q 0 till 180. quantization level - 0 means loss less compression, default 30
:: -f 0 till 15. how many flex bits trimmer during jpeg-xr compression. default 0, higher more compression and more artifacts. 
:: other tools: 	atfinfo -i test.atf
:: 				atfviewer gui to inspect atf
:: 				pngalpha -i test.png check if image has alpha, if output is alpha then yes
::          		pngsquare -i test.png is it a square or rectangle 
:: ==========================================
:: Creating cubemap:
::1. Rename your cubemap texture images in numerical order eg -X: hourglass0.png, +X: hourglass1.png, -Y: hourglass2.png, +Y: hourglass3.png, -Z: hourglass4.png, +Z: hourglass5.png
::2. add new flag -m
::./png2atf -c d -r -q 0 -f 0 -m -i YOUR_PROJECT_PATH/sky/cubetexture/hourglass0.png -o YOUR_PROJECT_PATH/sky/cubetexture/hourglass_cubemap2.atf
:: ==========================================
:: AS3 embed example ATF:
:: // Embed ATF-file
:: [Embed(source="/../asset/compressed_texture.atf", mimeType="application/octet-stream")]
:: private const _bytesAtf:Class;
:: // Create the material
:: var _texture:ATFTexture = new ATFTexture(new _bytesAtf());
:: var textureMaterial:TextureMaterial = new TextureMaterial(_texture);
:: ==========================================
:: AS3 Loader object:
:: var url:String = "../asset/compressed_texture.atf";
:: loader = new URLLoader();
:: loader.dataFormat = URLLoaderDataFormat.BINARY;
:: loader.addEventListener(Event.COMPLETE, textureLoadComplete);
:: var urlReq:URLRequest = new URLRequest(url);
:: loader.load(urlReq);
:: 
:: function textureLoadComplete(event:Event):void
:: {
:: 	// Create the material
::	var _texture:ATFTexture = new ATFTexture(loader.data);
:: 	var textureMaterial:TextureMaterial = new TextureMaterial(_texture); 
:: } 
:: ==========================================
