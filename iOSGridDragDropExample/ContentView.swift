//
//  ContentView.swift
//  iOSGridDragDropExample.git
//
//  Created by 영준 이 on 2024/01/08.
//

import SwiftUI

struct ContentView: View {
    class Colors {
        static let background: [Color] = [.black, .blue, .brown, .cyan, .gray, .green, .mint, .pink, .orange, .purple]
        static let foreground: [Color] = [.white, .white, .white, .black, .white, .black, .white, .white, .white, .white]
    }
    
    @State var datas = (1..<Colors.background.count).map{ CellData(name: "Data \($0)", background: Colors.background[$0], foreground: Colors.foreground[$0]) }
    @State var draggingData: CellData?
    
    let columns: [GridItem] = .init(repeating: .init(.fixed(100)), count: 4)
    
    var body: some View {
        VStack{
            LazyVGrid(columns: columns) {
                ForEach(datas, id: \.name) { data in
                    
                    Text(data.name)
                        .frame(width: 100, height: 100)
                        .foregroundColor(data.foreground)
                        .background(data.background)
                        .cornerRadius(8)
                        .border(.black)
                        .onDrag({
                            draggingData = data
                            return .init(object: data.name as NSString )
                        })
                        .onDrop(of: [.text], delegate: DataDropController(data: data, datas: $datas, draggingData: $draggingData))
                }
            }.gridCellColumns(4)
        }
        .padding()
    }
}

struct DataDropController: DropDelegate {
    let data: CellData
    @Binding var datas: [CellData]
    @Binding var draggingData: CellData?
    
    func performDrop(info: DropInfo) -> Bool {
        return true
    }
    
    func dropUpdated(info: DropInfo) -> DropProposal? {
        return .init(operation: .move)
    }
    
    func dropEntered(info: DropInfo) {
        guard let draggingData else {
            return
        }
        
        guard draggingData != data else {
            return
        }
        
        guard let sourceIndex = datas.firstIndex(where: { $0 == draggingData }),
              let destIndex = datas.firstIndex(where: { $0 == data }) else {
                return
        }
        
        debugPrint("Dragging \(draggingData.name)-\(sourceIndex) to \(data.name)-\(destIndex)")
        
        withAnimation(.default){
//            debugPrint("Dragging remove \(sourceIndex)")
            datas.remove(at: sourceIndex)
//            debugPrint("Dragging insert \(destIndex) data \(draggingData.name)")
            datas.insert(draggingData, at: destIndex)
        }
        
//        datas.forEach { _data in
//            debugPrint("datas \(_data.name)")
//        }
    }
}

#Preview {
    ContentView()
}
