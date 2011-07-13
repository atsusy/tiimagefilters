(function(){
	var module = require('jp.msmc.tiimagefilters');
	exports.load = function(arg){
		var image = module.load(arg);
		
		image.sharpen = function(amt){
			if(!amt){
				amt = 100;
			}
			
			return image.sobel([
				0, 		-amt, 		0,
				-amt, 4*amt+100, -amt,
				0,		-amt, 		0
			], 100)
		};
		
		image.vintage = function(){
			return image.greyscale()
						.contrast(5)
						.noise(6)
						.sepia(20)
						.channels({red:8, blue:2, green:4})
						.gamma(0.87)
						.vignette("40%", 30);
		};
		
		image.lomo = function(){
			return image.brightness(15)
						.exposure(15)
						.curves('rgb', [0,0], [200,0], [155,255], [255,255])
						.saturation(-20)
						.gamma(1.8)
						.vignette("50%", 60)
						.brightness(5);
		};
		
		image.clarity = function(grey){
			var filtered = image.vibrance(20)
								.curves('rgb', [5, 0], [130, 150], [190, 220], [250, 255])
								.sharpen(15)
								.vignette("45%", 20);
			if(grey){
				filtered.greyscale()
						.contrast(4);
			}
			return filtered;
		};
		
		return image;		
	};
})();



