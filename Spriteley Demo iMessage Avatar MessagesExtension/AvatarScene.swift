//
//  AvatarScene.swift
//  Spriteley Demo iMessage Avatar MessagesExtension
//
//  Created by Spriteley on 4/20/22.
//

import SceneKit
import Libparseley

class AvatarScene:SCNScene{
        
        var camera:SCNCamera!
        var cameraNode:SCNNode!
    
        var avatarNode:SCNNode!
        
        override init() {
            super.init()
            //camera
            camera = SCNCamera()
            cameraNode = SCNNode()
            cameraNode.camera = camera
            cameraNode.position = SCNVector3(0,0, 15)
            rootNode.addChildNode(cameraNode)
            
            addAvatar()
            rotateAvatar()
            
            
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func addAvatar(){
            let start = getCurrentMillis()
            let avatar: MeshC = RustManager().loadAvatar(path: "full_body_tri")
            print("load body time: \(getCurrentMillis() - start)")
            print("moving elapsed: \(getCurrentMillis() - start)")
            let verticies:[SCNVector3] = avatar.vertices.scnVector3
            let beforeVertexSource = getCurrentMillis()
            
            let vertexSource: SCNGeometrySource = SCNGeometrySource(vertices: verticies)
            print("create vertex source: \(getCurrentMillis() - beforeVertexSource)")
            print("moving elapsed: \(getCurrentMillis() - start)")
            let materials = avatar.materials

            var materialsData:[Data] = Array(repeating: Data(), count: materials.length)
    
            var materialsArr:[SCNMaterial] = []
            let materialsArrStartTime = getCurrentMillis()
  
            for i in 0..<materials.length{
                let materialPointer = materials.data + i
                let material = materialPointer.pointee.material
                let scnMaterial = SCNMaterial()
                //map to rgb
                //kd goes to diffuse contents
                scnMaterial.diffuse.contents = material.kd.color
                //ka is the ambient color
                scnMaterial.ambient.contents = material.ka.color
    //            ks is the specular color
                scnMaterial.specular.contents =  material.ks.color
                scnMaterial.emission.contents =  material.ke.color
    //            //metalness is ns
                scnMaterial.metalness.contents = material.ns
                scnMaterial.selfIllumination.contents = material.illum
    //            //illumination is lighting models complicated
                materialsArr.append(scnMaterial)
                
            }
            
            print("materials arr time: \(getCurrentMillis() - materialsArrStartTime)")
            print("materials arr elapsed: \(getCurrentMillis() - start)")

            let faces = avatar.faces
            var facesCountArr:[Int] = Array(repeating: 0, count: materialsArr.count)
            let facesArrStartTime = getCurrentMillis()
            for i in 0..<faces.length{
                let faceC:FaceC = faces.data.advanced(by: i).pointee
                let nodes:VecSwift_FaceNode = faceC.nodes
                let materialIndex:Int = Int(faceC.material)
                
                for j in 0..<nodes.length{
                    var nodeValue:Int32 = nodes.data.advanced(by: j).pointee.v - 1
                    let nodeData:Data = Data(bytes: &nodeValue, count: MemoryLayout<Int32>.size)
                    materialsData[materialIndex].append(nodeData)
                    
                }
                facesCountArr[Int(faceC.material)] += 1
            }
            
            print("faces arr time: \(facesArrStartTime - getCurrentMillis())")
            print("faces arr elapsed: \(getCurrentMillis() - start)")
            
            let indexStartTime = getCurrentMillis()
            var elementArr:[SCNGeometryElement] = []
            for i in (0..<materialsArr.count){
                let tableData = materialsData[i]
                let polygonVertexCounts: [Int32] = Array(repeating: 4, count: facesCountArr[i])
                var polygonVertexCountsData = Data(bytes: polygonVertexCounts, count: MemoryLayout<Int32>.stride * polygonVertexCounts.count)
                 polygonVertexCountsData.append(tableData)
                let data = polygonVertexCountsData
                elementArr.append(SCNGeometryElement(data: data, primitiveType: .polygon, primitiveCount: facesCountArr[i], bytesPerIndex: MemoryLayout<Int32>.stride))
            }
            print("convert to index and renderElement: \(getCurrentMillis() - indexStartTime)")
            let geometry = SCNGeometry(sources: [vertexSource], elements: elementArr)
            geometry.materials = materialsArr

            // Create a node and assign our custom geometry
            let node = SCNNode()
            node.geometry = geometry
            
            rootNode.addChildNode(node)
            self.avatarNode = node
            let end = getCurrentMillis()
            print("elapsed: \(start - end)")
        }
    
        func rotateAvatar(){
            let rotateRight = SCNAction.rotate(by: 2*CGFloat(Float.pi), around: SCNVector3(0, 1, 0), duration: 5)
            let rotateLeft = SCNAction.rotate(by: -2*CGFloat(Float.pi), around: SCNVector3(0, 1, 0), duration: 5)
            let sequence = SCNAction.sequence([rotateLeft,rotateRight])
            let repeatedSequence = SCNAction.repeatForever(sequence)
            avatarNode.runAction(repeatedSequence)
        }
    
    
        func getCurrentMillis()->Int64{
            return  Int64(NSDate().timeIntervalSince1970 * 1000)
        }
}
