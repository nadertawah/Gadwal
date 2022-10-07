//
//  FireBaseDB.swift
//  Gadwal
//
//  Created by nader said on 11/09/2022.
//

import FirebaseDatabase

class FireBaseDB : DBProtocol
{
    init()
    {
        let db = Database.database(url: Constants.fireBaseDBUrl)
        db.isPersistenceEnabled = true
        DBref = db.reference()
    }
    var DBref  : DatabaseReference
}
