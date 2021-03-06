package openfl._internal.renderer.canvas;


import lime.graphics.CanvasRenderContext;
import openfl._internal.renderer.AbstractRenderer;
import openfl._internal.renderer.RenderSession;
import openfl.display.Stage;

@:access(openfl.display.Stage)


class CanvasRenderer extends AbstractRenderer {
	
	
	private var context:CanvasRenderContext;
	
	
	public function new (stage:Stage, context:CanvasRenderContext) {
		
		super (stage);
		
		this.context = context;
		
		renderSession = new RenderSession ();
		renderSession.context = context;
		renderSession.roundPixels = true ;
		renderSession.renderer = this;
		#if !neko
		renderSession.maskManager = new CanvasMaskManager(renderSession);
		#end
		
	}
	
	
	public override function clear ():Void {
		
		for (stage3D in stage.stage3Ds) {
			
			stage3D.__renderCanvas (stage, renderSession);
			
		}
		
	}
	
	
	public override function render ():Void {
		
		renderSession.allowSmoothing = (stage.quality != LOW);
		
		context.setTransform (1, 0, 0, 1, 0, 0);
		context.globalAlpha = 1;
		
		if (!stage.__transparent && stage.__clearBeforeRender) {
			
			context.fillStyle = stage.__colorString;
			context.fillRect (0, 0, stage.stageWidth, stage.stageHeight);
			
		} else if (stage.__transparent && stage.__clearBeforeRender) {
			
			context.clearRect (0, 0, stage.stageWidth, stage.stageHeight);
			
		}
		
		stage.__renderCanvas (renderSession);
		
	}
	
	
}