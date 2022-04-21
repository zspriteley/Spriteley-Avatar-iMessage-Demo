//
//  RustManager.swift
//  Spriteley Demo iMessage Avatar MessagesExtension
//
//  Created by Spriteley on 4/20/22.
//

import Foundation
import Libparseley
import SceneKit

class RustManager{
    
    func loadAvatar(path:String = "full_body")->MeshC{
        let path = getPath(subFolder: path)
        let modePointer = stringtoUnsafeMutabalePointer(string: "sprite")
        let obj_file_path_cStringPointer  = stringtoUnsafeMutabalePointer(string: "")
        let sprt_file_path_String = stringtoUnsafeMutabalePointer(string: path)
        let output_file_c = stringtoUnsafeMutabalePointer(string: "output")
        let reorient = false
        let voxelize = true

        let commandOptions = CmdOptionsC(mode_c: modePointer, obj_file_path_c: obj_file_path_cStringPointer, sprt_file_path_c: sprt_file_path_String , output_file_c: output_file_c, reorient: reorient, voxelize: voxelize)
        
        let avatar = withUnsafePointer(to: commandOptions) { commandPointer in
            return load_avatar_from_disk_c(commandPointer)
        }
        
        return avatar
    }
    
    func getPath(subFolder:String = "full_body")->String{
        guard let path = Bundle.main.path(forResource: "resource/" + subFolder + "/sprite", ofType: "json") else { fatalError("resource folder missing")}
        return path
    }
    
    func stringToCCharArr(string:String)->[CChar]?{
        return string.cString(using: .utf8)
    }
    
    
    func stringtoUnsafeMutabalePointer(string:String)->UnsafeMutablePointer<CChar>{
        return string.withCString { unsafePointer in
            return UnsafeMutablePointer(mutating: unsafePointer)
        }
    }

    func CCharPointerToString(pointer:UnsafeMutablePointer<CChar>)->String{
        return String(cString: pointer)
    }
    
    func intArrToPointer32(arr:[Int])->UnsafeMutablePointer<Int32>?{
        let arr32:[Int32] = arr.map({Int32($0)})
        var first = arr32[0]
        var arrPointer:UnsafeMutablePointer<Int32>

        arrPointer = withUnsafeMutablePointer(to: &first) { pointer in
            return pointer
        }

        return arrPointer
    }
    
    func intArrToPointerU8(arr:[Int])->UnsafeMutablePointer<UInt8>?{
        var arrU8:[UInt8] = arr.map({UInt8($0)})
         return withUnsafeMutablePointer(to: &arrU8[0]) { pointer in
            return pointer
        }
    }

    func faceNodeVectorToArray(vector:VecSwift_FaceNode)->[FaceNode]{
       var arr:[FaceNode] = []
       for i in (0..<vector.length){
           let data = vector.data + i
           arr.append(data.pointee)
       }
       return arr
   }
    
    func faceCVectorToArray(vector :VecSwift_FaceC)->[FaceC]{
        var arr:[FaceC] = []
        for i in (0..<vector.length){
            let data = vector.data + i
            arr.append(data.pointee)
        }
        return arr
    }
    
    func vertic32ToSCNVector()->SCNVector3{
        return SCNVector3.init()
    }
}

extension PointC{
    var scnVector3:SCNVector3 {
        return SCNVector3(x,y,z)
    }
}

extension Sequence where Iterator.Element == PointC {
    var scnVector3:[SCNVector3] {
        return self.map({SCNVector3($0.x, $0.y, $0.z)})
    }
}

extension VecSwift_PointC{
    var scnVector3:[SCNVector3] {
        return (0..<length).map { i in
            return data.advanced(by: i).pointee.scnVector3
        }
    }
}


extension K{
    var color:UIColor{
        return  UIColor(red: self.r, green: self.g, blue: self.b, alpha: 1.0)
    }
}
