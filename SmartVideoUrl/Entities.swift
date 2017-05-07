//
//  Entities.swift
//  SmartVideo
//
//  Created by Serge Sahaguian on 08/04/2017.
//  Copyright © 2017 Serge Sahaguian. All rights reserved.
//

import Foundation

struct Chapitre {
    let name: String
    let start: Float
    let end: Float
    init(name: String, start: Float, end: Float) {
        self.name = name
        self.start = start
        self.end = end
    }
}

var tableChapitre: [Chapitre] = [
    Chapitre(name: "chapitre un", start: 0, end: 10),
    Chapitre(name: "chapitre deux", start: 10, end: 20)
]

struct InteractionBtn {
    let label: String, jumpToVideoName: String?, goto: Double?
    init(label: String, jumpToVideoName: String?, goto: Double?) {
        self.label = label
        self.jumpToVideoName = jumpToVideoName //si nil, on reste sur la vidéo courante
        self.goto = goto //si nil, on lace à 0
    }
}

//l'InteractionType display affiche des boutons et/ou un message temporaire
//InteractionType pause met la vidéo en pause en affichant des boutons (et un message si pas nil)
//Pour une pause, il faut laisser le paramètre displayEnd à nil
//si l'argument msg ets à nil, on affiche pas de message
//Pour afficher un message sans bouton, il suffit de choisir le type display
//mettre tous les interBtn à nil
class Interaction {
    enum InteractionType { case pause, display, none }
    let interactionType: InteractionType
    let id:Int
    let msg: String?
    let interBtn1: InteractionBtn?
    let interBtn2: InteractionBtn?
    let interBtn3: InteractionBtn?
    let displayStart: Float
    let displayEnd: Float?
    
    init(interactionType: InteractionType, id: Int, msg: String?, interBtn1: InteractionBtn?, interBtn2: InteractionBtn?, interBtn3: InteractionBtn?, displayStart: Float, displayEnd: Float?) {
        self.interactionType = interactionType
        self.id = id
        self.msg = msg
        self.interBtn1 = interBtn1
        self.interBtn2 = interBtn2
        self.interBtn3 = interBtn3
        self.displayStart = displayStart
        self.displayEnd = displayEnd
    }
}


var tableInteraction: [Interaction] = [
    Interaction(interactionType: .pause,
                id: 1,
                msg: "Presser l'un des boutons !",
                interBtn1: InteractionBtn(label: "Disney", jumpToVideoName: "Disney", goto: 55),
                interBtn2: InteractionBtn(label: "go 60", jumpToVideoName: nil, goto: 60),
                interBtn3: nil,
                displayStart: 5,
                displayEnd: nil),
    Interaction(interactionType: .pause,
                id: 2,
                msg: nil,
                interBtn1: InteractionBtn(label: "go 30", jumpToVideoName: nil, goto: 50),
                interBtn2: InteractionBtn(label: "go 65", jumpToVideoName: nil, goto: 65),
                interBtn3: InteractionBtn(label: "go 250", jumpToVideoName: nil, goto: 250),
                displayStart: 20,
                displayEnd: nil),
    Interaction(interactionType: .display,
                id: 3,
                msg: "Presser le bouton avant qu'il ne disparaisse...",
                interBtn1: InteractionBtn(label: "go 80", jumpToVideoName: nil, goto: 80),
                interBtn2: nil,
                interBtn3: nil,
                displayStart: 52,
                displayEnd: 65),
    Interaction(interactionType: .display,
                id: 4,
                msg: nil,
                interBtn1: InteractionBtn(label: "go 100", jumpToVideoName: nil, goto: 100),
                interBtn2: InteractionBtn(label: "go 150", jumpToVideoName: nil, goto: 150),
                interBtn3: InteractionBtn(label: "go 300", jumpToVideoName: nil, goto: 300),
                displayStart: 70,
                displayEnd: 85),
    Interaction(interactionType: .display,
                id: 5,
                msg: "Ceci est un test de d'affichage de texte sans bouton",
                interBtn1: nil,
                interBtn2: nil,
                interBtn3: nil,
                displayStart: 155,
                displayEnd: 165)
    
]
