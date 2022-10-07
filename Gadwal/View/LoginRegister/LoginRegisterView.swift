//
//  LoginRegisterView.swift
//  Gadwal
//
//  Created by nader said on 10/09/2022.
//

import SwiftUI
import FirebaseAuth
import FirebaseAuth

struct LoginRegisterView: View
{
    @State private var isPresentingNext : Bool
    @State private var isPresentingAlert = false
    @State private var scale = 0.0
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    @State private var isLogin = true
    @State private var department = "M_CS"
    @State private var alertMessage = ""
    @State private var isLoading = false
    
    private var departments = ["M_CS","P_CS"]
    var VM : LoginRegisterVM
    
    init(dbInstance : DBProtocol)
    {
        self.VM = LoginRegisterVM(dbInstance: dbInstance)
        isPresentingNext = Auth.auth().currentUser != nil
    }
    
    var body: some View
    {
        NavigationView
        {
            ZStack
            {
                LinearGradient(gradient: Gradient(colors: [.gray,Color.GadwalBGColor,Color.GadwalBGColor]), startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                
                GeometryReader
                {
                    geometry in
                    
                    VStack
                    {
                        Text(isLogin ? "Login" : "Register")
                            .fontWeight(.bold)
                            .font(.custom("Snell Roundhand Bold", fixedSize: 35))
                            .padding(20)
                        
                        Spacer()
                        
                        if(!isLogin)
                        {
                            ZStack(alignment: .leading)
                            {
                                Image(systemName: "person")
                                    .padding(.leading)
                                
                                TextField("Name", text: $name)
                                    .padding(.leading, 40)
                                    .background(Capsule().fill(Color.gray).opacity(0.1)
                                        .frame(height: 35, alignment: .center))
                                    
                            }
                            .transition(.scale)
                            .padding(10)
                        }
                        
                        ZStack(alignment: .leading)
                        {
                            Image(systemName: "at")
                                .padding(.leading)
                            
                            TextField("Email", text: Binding<String>(get: {email}, set: {email = $0.lowercased()}))
                                .padding(.leading,40)
                                .background(Capsule().fill(Color.gray).opacity(0.1)
                                    .frame(height: 35, alignment: .center))
                        }
                        .padding(10)
                        
                        
                        ZStack(alignment: .leading)
                        {
                            Image(systemName: "key")
                                .padding(.leading)
                            
                            SecureField("Password", text: $password)
                                .padding(.leading,40)
                                .background(Capsule().fill(Color.gray).opacity(0.1).frame(height: 35, alignment: .center))
                        }
                        .padding(10)
                        
                        if(!isLogin)
                        {
                            
                            HStack
                            {
                                Text("Department: ")
                                Picker("Department", selection: $department)
                                {
                                    ForEach(departments, id: \.self)
                                    {
                                        Text($0)
                                    }
                                }
                                .padding(5)
                            }
                            .transition(.scale)
                        }
                        
                        Button(isLogin ? "Login" : "Register")
                        {
                            if !email.isEmpty && !password.isEmpty
                            {
                                if isLogin
                                {
                                    isLoading = true
                                    
                                    //Login
                                    VM.login(email, password)
                                    {
                                        result , error in
                                        if result != nil
                                        {
                                            isPresentingNext = true
                                        }
                                        else
                                        {
                                            alertMessage = error?.localizedDescription ?? ""
                                            isPresentingAlert = true
                                        }
                                        isLoading = false
                                    }
                                }
                                else
                                {
                                    if name.isEmpty
                                    {
                                        alertMessage = "All fields are required!"
                                        isPresentingAlert = true
                                    }
                                    else
                                    {
                                        //Register new user
                                        VM.register(name: name, email: email, password: password, department: department)
                                        {
                                            result , error in
                                            if result != nil
                                            {
                                                alertMessage = "Registerd! You can login now."
                                                isPresentingAlert = true
                                            }
                                            else
                                            {
                                                alertMessage = error?.localizedDescription ?? ""
                                                isPresentingAlert = true
                                            }
                                        }
                                    }
                                }
                            }
                            else
                            {
                                alertMessage = "All fields are required!"
                                isPresentingAlert = true
                            }
                        }
                        .frame(width: geometry.size.width * 0.75, height: 35, alignment: .center)
                        .background(Color.GadwalBGColor)
                        .foregroundColor(.white)
                        .cornerRadius(20)
                        .shadow(color: .GadwalBGColor, radius: 10, x: 10, y: 5)
                        .alert(alertMessage, isPresented:  $isPresentingAlert){}
                        .padding(.top)
                        
                        Spacer()
                        
                        Button(isLogin ? "Register" : "Login")
                        {
                            withAnimation
                            {
                                isLogin.toggle()
                            }
                        }
                        .foregroundColor(.black)
                        .padding()
                        .background(Capsule().fill(Color.gray).opacity(0.1).frame(height: 35, alignment: .center))
                        .padding(.bottom, 20)
                        
                    }
                    .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                    .background(.white)
                    .cornerRadius(100, corners: [.topLeft, .bottomRight])
                    .shadow(color: .black, radius: 10, x: 5, y: 5)
                }
                .frame(width: UIScreen.screenWidth * 0.75, height: isLogin ? UIScreen.screenHeight * 0.45 : UIScreen.screenHeight * 0.65, alignment: .center)
            
                if isLoading
                {
                    LoadingView()
                }
                
                NavigationLink("",destination: NavigationLazyView(StudentInfoView(dbInstance: VM.dbInstance)), isActive: $isPresentingNext)

            }
            .navigationBarHidden(true)
        }
        
    }
}
