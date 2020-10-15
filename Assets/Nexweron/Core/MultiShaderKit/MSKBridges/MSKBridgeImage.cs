using Nexweron.Core.MSK;
using UnityEngine;

public class MSKBridgeImage : TargetRenderBase
{
	public Texture sourceTexture;
	public MSKController mskController;
	
	private Texture _sourceTexture;
	private void SetSourceTexture(Texture value, bool isForce = false) {
		if (_sourceTexture != value || isForce) {
			_sourceTexture = value;
			if (mskController != null) {
				mskController.SetSourceTexture(_sourceTexture);
			} else {
				Debug.LogError("MSKBridgeImage | mskController = null");
			}
		}
	}
	
	public bool renderOnAwake = true;
	public bool renderOnUpdate = true;

	private RenderTexture _texture;
	public RenderTexture texture {
		get { return _texture; }
	}

	void OnEnable() {
		UpdateTarget();
	}

	void Start() {
		if (renderOnAwake) {
			SetSourceTexture(sourceTexture, true);
			Render();
		}
	}

	void Update() {
		if (renderOnUpdate) {
			SetSourceTexture(sourceTexture);
			Render();
		}
	}

	public void Render() {
		_texture = mskController.RenderIn();
		UpdateTargetTexture(_texture);
	}
}
