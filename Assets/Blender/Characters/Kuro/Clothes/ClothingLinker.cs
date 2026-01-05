using UnityEngine;
using System.Collections.Generic;

public class ClothingLinker : MonoBehaviour
{
    public SkinnedMeshRenderer targetRig; // The main body mesh

    void Start()
    {
        SkinnedMeshRenderer myRenderer = GetComponent<SkinnedMeshRenderer>();
        Transform[] targetBones = targetRig.bones;
        Transform[] newBones = new Transform[myRenderer.bones.Length];

        // Create a dictionary for fast lookup of the player's bones
        Dictionary<string, Transform> boneMap = new Dictionary<string, Transform>();
        foreach (Transform bone in targetBones)
        {
            boneMap[bone.name] = bone;
        }

        // Map the clothing bones to the player's bones by name
        for (int i = 0; i < myRenderer.bones.Length; i++)
        {
            string boneName = myRenderer.bones[i].name;
            if (boneMap.TryGetValue(boneName, out Transform foundBone))
            {
                newBones[i] = foundBone;
            }
            else
            {
                Debug.LogWarning("Could not find bone: " + boneName + " on target rig.");
            }
        }

        myRenderer.bones = newBones;
        myRenderer.rootBone = targetRig.rootBone;
    }
}