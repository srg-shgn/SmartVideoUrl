//
//  Entities.swift
//  SmartVideo
//
//  Created by Serge Sahaguian on 08/04/2017.
//  Copyright © 2017 Serge Sahaguian. All rights reserved.
//

import Foundation

struct InteractionBtn {
    let label: String, goto: Float?
    init(label: String, goto: Float?) {
        self.label = label
        self.goto = goto
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

