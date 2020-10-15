using UnityEngine;
using UnityEngine.UI;

public class TargetRenderBase : MonoBehaviour
{
	public enum RenderMode {
		None,
		APIOnly,
		RenderTexture,
		MaterialOverride,
		RawImage
	}

	[SerializeField]
	protected RenderMode _renderMode = RenderMode.APIOnly;
	public RenderMode renderMode {
		get { return _renderMode; }
		set { SetRenderMode(value); }
	}
	protected void SetRenderMode(RenderMode mode, bool isForce = false) {
		if (_renderMode != mode || isForce) {
			_renderMode = mode;
		}
	}
	
	[SerializeField]
	protected RenderTexture _targetRenderTexture;
	public RenderTexture targetRenderTexture {
		get { return _targetRenderTexture; }
		set {
			if (_renderMode == RenderMode.RenderTexture) {
				SetTargetRenderTexture(value);
			} else {
				Debug.LogError("TargetRenderBase | targetTexture can be set only in RenderMode.RenderTexture mode");
			}
		}
	}
	protected void SetTargetRenderTexture(RenderTexture value, bool isForce = false) {
		if (_targetRenderTexture != value || isForce) {
			_targetRenderTexture = value;
		}
	}

	[SerializeField]
	protected Renderer _targetRenderer;
	public Renderer targetRenderer {
		get { return _targetRenderer; }
		set {
			if (_renderMode == RenderMode.MaterialOverride) {
				SetTargetRenderer(value);
			} else {
				Debug.LogError("TargetRenderBase | targetRenderer can be set only in RenderMode.MaterialOverride mode");
			}
		}
	}
	protected void SetTargetRenderer(Renderer value, bool isForce = false) {
		if (_targetRenderer != value || isForce) {
			_targetRenderer = value;
			UpdateTargetMaterial();
		}
	}
	protected void UpdateTargetMaterial() {
		if (_targetRenderer != null) {
			SetTargetMaterial(_targetRenderer.material, true);
		}
	}
	protected Material _targetMaterial;
	protected void SetTargetMaterial(Material value, bool isForce = false) {
		if (_targetMaterial != value || isForce) {
			_targetMaterial = value;
		}
	}
	protected void SetTargetMaterialMainTexture(Texture value, bool isForce = false) {
		if (_targetMaterial != null) {
			if (_targetMaterial.mainTexture != value || isForce) {
				_targetMaterial.mainTexture = value;
			}
		}
	}

	[SerializeField]
	protected RawImage _targetRawImage;
	public RawImage targetRawImage {
		get { return _targetRawImage; }
		set {
			if (_renderMode == RenderMode.RawImage) {
				SetTargetRawImage(value);
			} else {
				Debug.LogError("TargetRenderBase | targetRawImage can be set only in RenderMode.RawImage mode");
			}
		}
	}
	protected void SetTargetRawImage(RawImage value, bool isForce = false) {
		if (_targetRawImage != value || isForce) {
			_targetRawImage = value;
		}
	}
	protected void SetTargetRawImageTexture(Texture value, bool isForce = false) {
		if (_targetRawImage != null) {
			if (_targetRawImage.texture != value || isForce) {
				_targetRawImage.texture = value;
			}
		}
	}

	protected void UpdateTarget() { // call on awake
		//if (_renderMode == RenderMode.RenderTexture) { // not required
		//	SetTargetRenderTexture(_targetRenderTexture, true);
		//} else 
		if (_renderMode == RenderMode.MaterialOverride) {
			SetTargetRenderer(_targetRenderer, true);
		} else if (_renderMode == RenderMode.RawImage) {
			SetTargetRawImage(_targetRawImage, true);
		}
	}

	protected void UpdateTargetTexture(Texture texture) {
		if (_renderMode == RenderMode.RenderTexture) {
			_targetRenderTexture.DiscardContents();
			Graphics.Blit(texture, _targetRenderTexture);
		} else if (_renderMode == RenderMode.MaterialOverride) {
			SetTargetMaterialMainTexture(texture);
		} else if (_renderMode == RenderMode.RawImage) {
			SetTargetRawImageTexture(texture);
		}
	}
}