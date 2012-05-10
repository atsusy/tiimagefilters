var window = Titanium.UI.createWindow();
var imagefilter = require('imagefilter');

var filterDescs = { 
	Exposure:[
		{
			name:'Adjust',
			type:'integer',
			min:0,
			max:100
		}	
	],
	Channels:[
		{
			name:'R',
			type:'integer',
			min:0,
			max:255
		},
		{
			name:'G',
			type:'integer',
			min:0,
			max:255
		},
		{
			name:'B',
			type:'integer',
			min:0,
			max:255
		}
	],
	Greyscale:[
	],
	Sepia:[
		{
			name:'Adjust',
			type:'integer',
			min:0,
			max:100
		}	
	],
	Hue:[
		{
			name:'Adjust',
			type:'integer',
			min:0,
			max:100
		}	
	],
	Contrast:[
		{
			name:'Adjust',
			type:'integer',
			min:-100,
			max:100
		}	
	],
	Brightness:[
		{
			name:'Adjust',
			type:'integer',
			min:-100,
			max:100
		}	
	],
	Saturation:[
		{
			name:'Adjust',
			type:'integer',
			min:-100,
			max:100
		}	
	],
	Vibrance:[
		{
			name:'Adjust',
			type:'integer',
			min:-100,
			max:100
		}	
	],
	Colorize:[
		{
			name:'R',
			type:'integer',
			min:0,
			max:255
		},
		{
			name:'G',
			type:'integer',
			min:0,
			max:255
		},
		{
			name:'B',
			type:'integer',
			min:0,
			max:255
		},
		{
			name:'Level',
			type:'integer',
			min:0,
			max:100
		}	
	],
	Invert:[
	],
	Gamma:[
		{
			name:'Adjust',
			type:'numeric',
			min:0,
			max:5.0
		}	
	],
	Noise:[
		{
			name:'Adjust',
			type:'integer',
			min:0,
			max:100
		}	
	],
	Clip:[
		{
			name:'Adjust',
			type:'integer',
			min:0,
			max:100
		}	
	],
	Vignette:[
		{
			name:'Area',
			type:'integer',
			min:0,
			max:100
		},
		{
			name:'Power',
			type:'integer',
			min:0,
			max:100
		}		
	]
};
var filterViews = [];
var targetImage = imagefilter.load('example.jpg').imageAsResized(600, 600).imageWithRoundedCorner(16);

function buildFilterOperator(desc){
	var view = Titanium.UI.createView({
		backgroundColor:'black',
		borderRadius:4,
		opacity:0.0,
		left:20,
		right:20,
		top:100,
		bottom:80,
		desc:desc
	});
	
	var y = 30;
	for(var i = 0; i < desc.length; i++){
		var arg = desc[i];
		if(arg.type === 'integer' || arg.type === 'numeric'){
			var title = Titanium.UI.createLabel({
				top:y,
				left:8,
				font:{fontSize:'16', fontFamily:'Arial', fontWeight:'Bold'},
				text:arg.name,
				color:'white',
				width:60,
				textAlign:'center',
				height:'auto'
			})
			
			var slider = Titanium.UI.createSlider({
				top:y,
				min:arg.min,
				max:arg.max,
				value:0,
				height:32,
				width:'50%'
			});
			
			var value = Titanium.UI.createLabel({
				top:y - 2,
				right:25,
				font:{fontSize:'22', fontFamily:'Arial', fontWeight:'Bold'},
				text:'0',
				color:'white',
				width:'auto',
				height:'auto'
			});
			view.add(title);
			view.add(slider);
			view.add(value);
			
			view[arg.name] = slider;
			slider.addEventListener('touchend', function(e){
				view.fireEvent('render', { args:view.arguments() });
			});
			slider.addEventListener('change', (function(v){
				return function(e){
					if(arg.type === 'integer'){
						v.text = parseInt(e.value, 10);
					}else{
						v.text = e.value.toFixed(1);
					}
				}
			})(value));
			y += 40;
		}
	}
	
	view.arguments = function() {
		var arguments = [];
		for(var i = 0; i < this.desc.length; i++){
			var arg = this.desc[i];
			arguments.push(view[arg.name].value);
		}
		return arguments;
	};
	
	return view;
};

for(var filterName in filterDescs){
	var filterDesc = filterDescs[filterName];
	
	var image = Titanium.UI.createImageView({
		top:20,
		left:10,
		right:10,
		image:targetImage
	});

	var view = Titanium.UI.createView({
		backgroundColor:'transparent',
		title:filterName,
		desc:filterDesc,
		image:image
	});
	
	view.add(image);	

	if(view.desc.length > 0){
		var operator = buildFilterOperator(filterDesc);
		operator.addEventListener('render', (function(name){
			return function(e) { 
				var imageView = filterViews[name].image; 
				var func = name.toLowerCase();

				if(!targetImage[func].apply){
					targetImage[func].apply = Function.prototype.apply;
				}
				imageView.image = targetImage[func].apply(targetImage, e.args);
			};
		})(filterName));
		view.operator = operator;
		view.add(operator);
		view.addEventListener('touchend', (function(v){
			return function(e){
				if(v.operating){
					v.operator.animate({opacity:0.0, duration:200});
				}else{
					v.operator.animate({opacity:0.9, duration:200});
				}
				v.operating = !v.operating;
			};
		})(view));
	}

	filterViews.push(view);
	filterViews[filterName] = view;
}

var currentFilter = filterViews[0];

var scrollView = Titanium.UI.createScrollableView({
	views:filterViews,
	showPagingControl:true,
	bottom:55
});

var filterTitle = Titanium.UI.createLabel({
	text:currentFilter.title,
	textAlign:'center',
	color:'white',
	height:24,
	bottom:70,
});

var help = Titanium.UI.createLabel({
	text:'Touch image, you can operate filter.',
	font:{fontSize:14},
	top:10,
	color:'white',
	width:'auto',
	height:'auto',
});

var picture = Titanium.UI.createButton({
	title:'Open Photo Gallery',
	width:'80%',
	height:32,
	bottom:16,
});

picture.addEventListener('click', function(e){
	var dialog = Titanium.UI.createOptionDialog({
		title:'',
		options:['Take Photo', 'Choose Exsiting Photo', 'Cancel'],
		cancel:2
	});
	dialog.show();
	dialog.addEventListener('click', function(e){
		if(e.index == 0){
			Titanium.Media.showCamera({
				success: function(e) {
					targetImage = imagefilter.load(e.media).imageAsResized(600, 600).imageWithRoundedCorner(16);
					for(var i = 0; i < filterViews.length; i++){
						var filterView = filterViews[i];
						filterView.image.image = targetImage;
					}
				},
				allowEditing:true,
				mediaTypes:[Titanium.Media.MEDIA_TYPE_PHOTO]
			});
		}
		if(e.index == 1){
			Titanium.Media.openPhotoGallery({
				success: function(e) {
					targetImage = imagefilter.load(e.media).imageAsResized(600, 600).imageWithRoundedCorner(16);
					for(var i = 0; i < filterViews.length; i++){
						var filterView = filterViews[i];
						filterView.image.image = targetImage;
					}
				},
				allowEditing:true,
				mediaTypes:[Titanium.Media.MEDIA_TYPE_PHOTO]
			})
		}
	});
	
});

scrollView.addEventListener('scroll', function(e){
	if(currentFilter !== filterViews[e.currentPage]){
		currentFilter = filterViews[e.currentPage];
		filterTitle.text = currentFilter.title;
		
		if(currentFilter.desc.length == 0){
			currentFilter.image.image = targetImage[currentFilter.title.toLowerCase()]();
		}
	}
});

window.add(scrollView);
window.add(filterTitle)
window.add(help);
window.add(picture);

window.open();

