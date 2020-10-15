using UnityEngine;
using UnityEditor;
using UnityEditor.AnimatedValues;
using UnityEngine.UI;

[CustomEditor(typeof(TargetRenderBase), true)]
public class TargetRenderBaseEditor : Editor
{
	SerializedProperty _scriptProperty;

	SerializedProperty _renderModeProperty;
	SerializedProperty _targetRenderTextureProperty;
	SerializedProperty _targetRendererProperty;
	SerializedProperty _targetRawImageProperty;

	AnimBool _showTargetTexture = new AnimBool();
	AnimBool _showRenderer = new AnimBool();
	AnimBool _showRawImage = new AnimBool();

	private void OnEnable() {
		_scriptProperty = serializedObject.FindProperty("m_Script");
		
		_renderModeProperty = serializedObject.FindProperty("_renderMode");
		_targetRenderTextureProperty = serializedObject.FindProperty("_targetRenderTexture");
		_targetRendererProperty = serializedObject.FindProperty("_targetRenderer");
		_targetRawImageProperty = serializedObject.FindProperty("_targetRawImage");
		
		var renderMode = (TargetRenderBase.RenderMode)_renderModeProperty.enumValueIndex;
		_showTargetTexture.value = (renderMode == TargetRenderBase.RenderMode.RenderTexture);
		_showRenderer.value = (renderMode == TargetRenderBase.RenderMode.MaterialOverride);
		_showRawImage.value = (renderMode == TargetRenderBase.RenderMode.RawImage);

		_showTargetTexture.valueChanged.AddListener(Repaint);
		_showRenderer.valueChanged.AddListener(Repaint);
		_showRawImage.valueChanged.AddListener(Repaint);
	}
	
	protected virtual void OnDisable() {
		_showTargetTexture.valueChanged.RemoveListener(Repaint);
		_showRenderer.valueChanged.RemoveListener(Repaint);
		_showRawImage.valueChanged.RemoveListener(Repaint);
	}
	
	public override void OnInspectorGUI() {
		serializedObject.Update();

		//Script
		EditorGUI.BeginDisabledGroup(true);
		{ EditorGUILayout.PropertyField(_scriptProperty, true, new GUILayoutOption[0]); }
		EditorGUI.EndDisabledGroup();

		EditorGUILayout.Space();

		//Default
		DrawPropertiesExcluding(serializedObject, new string[] { _scriptProperty.name, _renderModeProperty.name, _targetRenderTextureProperty.name, _targetRendererProperty.name, _targetRawImageProperty.name });

		var instance = serializedObject.targetObject as TargetRenderBase;

		EditorGUILayout.Space();

		//Render
		EditorGUILayout.PropertyField(_renderModeProperty);

		var renderMode = (TargetRenderBase.RenderMode)_renderModeProperty.enumValueIndex;
		_showTargetTexture.target = (!_renderModeProperty.hasMultipleDifferentValues && renderMode == TargetRenderBase.RenderMode.RenderTexture);
		_showRenderer.target = (!_renderModeProperty.hasMultipleDifferentValues && renderMode == TargetRenderBase.RenderMode.MaterialOverride);
		_showRawImage.target = (!_renderModeProperty.hasMultipleDifferentValues && renderMode == TargetRenderBase.RenderMode.RawImage);

		++EditorGUI.indentLevel;
		{
			if (EditorGUILayout.BeginFadeGroup(_showTargetTexture.faded)) {
				EditorGUILayout.PropertyField(_targetRenderTextureProperty);
			}
			EditorGUILayout.EndFadeGroup();

			if (EditorGUILayout.BeginFadeGroup(_showRenderer.faded)) {
				var renderer = _targetRendererProperty.objectReferenceValue as Renderer;
				if (renderer == null) {
					renderer = (target as TargetRenderBase).GetComponent<Renderer>();
					_targetRendererProperty.objectReferenceValue = renderer;
				}
				EditorGUILayout.PropertyField(_targetRendererProperty);
			}
			EditorGUILayout.EndFadeGroup();

			if (EditorGUILayout.BeginFadeGroup(_showRawImage.faded)) {
				var rawImage = _targetRawImageProperty.objectReferenceValue as RawImage;
				if (rawImage == null) {
					rawImage = (target as TargetRenderBase).GetComponent<RawImage>();
					_targetRawImageProperty.objectReferenceValue = rawImage;
				}
				EditorGUILayout.PropertyField(_targetRawImageProperty);
			}
			EditorGUILayout.EndFadeGroup();
		}
		--EditorGUI.indentLevel;
		
		//Setters
		if (EditorApplication.isPlaying) {
			if (instance.renderMode != (TargetRenderBase.RenderMode)_renderModeProperty.enumValueIndex) {
				instance.renderMode = (TargetRenderBase.RenderMode)_renderModeProperty.enumValueIndex;
			}
			if (instance.targetRenderer != _targetRendererProperty.objectReferenceValue) {
				instance.targetRenderer = _targetRendererProperty.objectReferenceValue as Renderer;
			}
			if (instance.targetRenderTexture != _targetRenderTextureProperty.objectReferenceValue) {
				instance.targetRenderTexture = _targetRenderTextureProperty.objectReferenceValue as RenderTexture;
			}
			if (instance.targetRawImage != _targetRawImageProperty.objectReferenceValue) {
				instance.targetRawImage = _targetRawImageProperty.objectReferenceValue as RawImage;
			}
		}
		
		serializedObject.ApplyModifiedProperties();
	}
}
