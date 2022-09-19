//
//  CustomAlert.swift
//  Gadwal
//
//  Created by nader said on 17/09/2022.
//

import SwiftUI

struct CustomAlert: View
{
    @Binding var textEntered: String
    @Binding var showingAlert: Bool
    @Binding var isValid : Bool
    @Binding var okPressed : Bool
    
    @State var message : String
    
    var body: some View
    {
        ZStack
        {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                
            VStack
            {
                Text("Attention")
                    .font(.title)
                    .foregroundColor(.black)
                    .padding(.top)
                
                Text(message)
                    .font(.body)
                    .foregroundColor(.black)
                    .fixedSize(horizontal: false , vertical: true)
                    .padding()
                
                Divider()
                
                TextField("Enter here", text: $textEntered)
                    .padding(5)
                    .background(Color.gray.opacity(0.2))
                    .foregroundColor(.black)
                    .border(isValid ? .green : .red, width: 3)
                    .padding(.horizontal, 20)
                    .onChange(of: textEntered)
                    {
                        let credits = Float($0)
                        isValid = credits != nil && credits! > 0 && credits! <= 18
                    }
                
                Divider()
                
                HStack
                {
                    Group
                    {
                        Button("Cancel")
                        {
                            withAnimation
                            {
                                self.showingAlert.toggle()
                            }
                        }
                        
                        Button("Ok")
                        {
                            withAnimation
                            {
                                self.showingAlert.toggle()
                                okPressed = true
                            }
                        }
                        .disabled(!isValid)
                    }
                    .padding()
                }
                .padding(30)
                .padding(.horizontal, 40)
            }
        }
        .frame(width: 300, height: 200)
    }
}
