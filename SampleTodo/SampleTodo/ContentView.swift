//
//  ContentView.swift
//  SampleTodo
//
//  Created by Nekokichi on 2020/09/18.
//                    NavigationLink(destination: TodoItemEditView()) {
//                        Text(todoItem.name)
//                    }.onTapGesture {
//                        print("fasfeafawf")
//                    }
//                    NavigationLink(
//                        destination: TodoItemEditView(),
//                        isActive: $isActiveNVC,
//                        label: {


//                            Text(todoItem.name).onTapGesture {
//                                todoListObject.selectedTodoItemID = todoItem.id
//                                isActiveNVC = true
//                            }
//                        }).onTapGesture{
//                            todoListObject.selectedTodoItemID = todoItem.id
//                            isActiveNVC.toggle()
//                        }
//                    NavigationLink(destination: TodoItemEditView()) {
//                        Text(todoItem.name).onTapGesture{
//
//                            print(todoItem.id, todoListObject.selectedTodoItemID)
//                        }
//                    }

import SwiftUI

struct TodoItem: Identifiable {
    var id: Int
    var name: String
}

class TodoListObject: ObservableObject {
    @Published var todoList: Array<TodoItem> = [TodoItem(id: 0, name: "Apple"),TodoItem(id: 1, name: "Orange"),TodoItem(id: 2, name: "Banana")]
    @Published var selectedTodoItemID: Int = 0
}

struct ContentView: View {
    @EnvironmentObject var todoListObject: TodoListObject
    var body: some View {
        NavigationView {
            List {
                ForEach(todoListObject.todoList) { item in
                    NavigationLink(
                        destination: TodoItemEditView().onAppear {
                            todoListObject.selectedTodoItemID = item.id
                        }) {
                        Text(item.name)
                    }
                }
                .onDelete { (offsets) in
                    // 例：三つ目のセル（行番号が２）を編集後、Orangeを削除すると、index out of range、のエラーが出る
                    // 存在しない三つ目のセルを参照してしまっているから？
                    // 編集後に初期化、更新すればいい
                    todoListObject.todoList.remove(atOffsets: offsets)
                    todoListObject.selectedTodoItemID = 0
                    updateIndex()
                }
            }
            .navigationBarTitle("Todoリスト", displayMode: .inline)
            .navigationBarItems(leading: EditButton(), trailing: NavigationLink(destination: TodoItemAddView(),label: {Text("Add")})
            )
        }
    }
    func updateIndex() {
        // アイテム数が1つ以上で処理
        if todoListObject.todoList.count > 0 {
            for i in 0...todoListObject.todoList.count-1 {
                todoListObject.todoList[i].id = i
            }
        }
    }
}

struct TodoItemAddView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var todoListObject: TodoListObject
    @State var inputText: String = ""
    var body: some View {
        Text("")
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading:
                Button("<戻る") {
                    self.presentationMode.wrappedValue.dismiss()
                }
            )
        VStack {
            TextField("入力してください", text: $inputText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            Button(action: {
                todoListObject.todoList.append(TodoItem(id: todoListObject.todoList.count, name: inputText))
                self.presentationMode.wrappedValue.dismiss()
            }, label: {
                Text("Todoアイテムを追加")
            })
        }
    }
}

struct TodoItemEditView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var todoListObject: TodoListObject
    @State var editedText: String = ""
    var body: some View {
        Text("")
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading:
                Button("<戻る") {
                    self.presentationMode.wrappedValue.dismiss()
                }
            )
        VStack {
            if todoListObject.todoList.count > 0 {
                TextField("入力してください", text: $todoListObject.todoList[todoListObject.selectedTodoItemID].name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
            }
            Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }, label: {
                Text("Todoアイテムを更新")
            })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
        TodoItemAddView()
    }
}
