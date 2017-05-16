//
//  Entities.swift
//  SmartVideo
//
//  Created by Serge Sahaguian on 08/04/2017.
//  Copyright © 2017 Serge Sahaguian. All rights reserved.
//

import Foundation

enum OperatorType { case goBack, goForward }

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
    Chapitre(name: "chapitre deux", start: 10, end: 20),
    Chapitre(name: "chapitre trois", start: 20, end: 30)
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
//Pour le type loop :
//chapterToLoop est la propriété name de l'objet chapter
//il faut juste renseigner le label de l'interBtn1 de la loop et laisser à nil le jumpToVideoName et le goto
//le goto se claculera automatiquement à partir de la propriété end de l'objet Chapitre auquel la loop se réfère
class Interaction {
    enum InteractionType { case pause, display, loop, none }
    let interactionType: InteractionType
    let id:Int
    let msg: String?
    let interBtn1: InteractionBtn?
    let interBtn2: InteractionBtn?
    let interBtn3: InteractionBtn?
    let displayStart: Float?
    let displayEnd: Float?
    let chapterToLoop: String?
    var loopActivated: Bool?
    
    init(interactionType: InteractionType, id: Int, msg: String?, interBtn1: InteractionBtn?, interBtn2: InteractionBtn?, interBtn3: InteractionBtn?, displayStart: Float?, displayEnd: Float?, chapterToLoop: String?, loopActivated: Bool?) {
        self.interactionType = interactionType
        self.id = id
        self.msg = msg
        self.interBtn1 = interBtn1
        self.interBtn2 = interBtn2
        self.interBtn3 = interBtn3
        self.displayStart = displayStart
        self.displayEnd = displayEnd
        self.chapterToLoop = chapterToLoop
        self.loopActivated = loopActivated
    }
}

class Interaction2 {
    let id: String
    let msg: String?
    let interBtn1: InteractionBtn?
    
    init(id: String, msg: String?, interBtn1: InteractionBtn?) {
        self.id = id
        self.msg = msg
        self.interBtn1 = interBtn1
    }
}

class LoopInter: Interaction2 {
    var chapterToLoop: String?
    var loopActivated: Bool = false
    
    init(id: String, msg: String?, interBtn1:InteractionBtn?, chapterToLoop: String, loopActivated: Bool) {
        super.init(id: id, msg: msg, interBtn1: interBtn1)
        self.chapterToLoop = chapterToLoop
        self.loopActivated = loopActivated
    }
}

class PauseInter: Interaction2 {
    var interBtn2: InteractionBtn?
    var interBtn3: InteractionBtn?
    var displayStart: Float?
    
    init(id: String, msg: String?, interBtn1: InteractionBtn?, interBtn2: InteractionBtn?, interBtn3: InteractionBtn?, displayStart: Float) {
        super.init(id: id, msg: msg, interBtn1: interBtn1)
        self.interBtn2 = interBtn2
        self.interBtn3 = interBtn3
        self.displayStart = displayStart
    }
}

class DisplayInter: PauseInter {
    var displayEnd: Float?
    
    init(id: String, msg: String?, interBtn1: InteractionBtn?, interBtn2: InteractionBtn?, interBtn3: InteractionBtn?, displayStart: Float, displayEnd: Float) {
        super.init(id: id, msg: msg, interBtn1: interBtn1, interBtn2: interBtn2, interBtn3: interBtn3, displayStart: displayStart)
        self.displayEnd = displayEnd
    }
}


class SumaryInter: PauseInter {
    var interBtn4: InteractionBtn?
    var interBtn5: InteractionBtn?
    var interBtn6: InteractionBtn?
    var interBtn7: InteractionBtn?
    var interBtn8: InteractionBtn?
    var interBtn9: InteractionBtn?
    var interBtn10: InteractionBtn?
    var interBtn11: InteractionBtn?
    var interBtn12: InteractionBtn?
    
    init(id: String, msg: String?, interBtn1: InteractionBtn?, interBtn2: InteractionBtn?, interBtn3: InteractionBtn?,
         interBtn4: InteractionBtn, interBtn5: InteractionBtn, interBtn6: InteractionBtn, interBtn7: InteractionBtn,
         interBtn8: InteractionBtn, interBtn9: InteractionBtn, interBtn10: InteractionBtn, interBtn11: InteractionBtn,
         interBtn12: InteractionBtn, displayStart: Float) {
        super.init(id: id, msg: msg, interBtn1: interBtn1, interBtn2: interBtn2, interBtn3: interBtn3, displayStart: displayStart)
        self.interBtn4 = interBtn4
        self.interBtn5 = interBtn5
        self.interBtn6 = interBtn6
        self.interBtn7 = interBtn7
        self.interBtn8 = interBtn8
        self.interBtn9 = interBtn9
        self.interBtn10 = interBtn10
        self.interBtn11 = interBtn11
        self.interBtn12 = interBtn12
    }
}

var tableInteraction: [Interaction] = [
    Interaction(interactionType: .loop,
                id: 6,
                msg: "Pressez le bouton pour mettre fin à la boucle",
                interBtn1: InteractionBtn(label: "chapitre suivant", jumpToVideoName: nil, goto: nil),
                interBtn2: nil,
                interBtn3: nil,
                displayStart: nil,
                displayEnd: nil,
                chapterToLoop: "chapitre un",
                loopActivated: true),
    Interaction(interactionType: .pause,
                id: 1,
                msg: "Presser l'un des boutons !",
                interBtn1: InteractionBtn(label: "Disney", jumpToVideoName: "Disney", goto: 55),
                interBtn2: InteractionBtn(label: "go 60", jumpToVideoName: nil, goto: 60),
                interBtn3: nil,
                displayStart: 13,
                displayEnd: nil,
                chapterToLoop: nil,
                loopActivated: nil),
    Interaction(interactionType: .pause,
                id: 2,
                msg: nil,
                interBtn1: InteractionBtn(label: "go 30", jumpToVideoName: nil, goto: 50),
                interBtn2: InteractionBtn(label: "go 65", jumpToVideoName: nil, goto: 65),
                interBtn3: InteractionBtn(label: "go 250", jumpToVideoName: nil, goto: 250),
                displayStart: 20,
                displayEnd: nil,
                chapterToLoop: nil,
                loopActivated: nil),
    Interaction(interactionType: .display,
                id: 3,
                msg: "Presser le bouton avant qu'il ne disparaisse...",
                interBtn1: InteractionBtn(label: "go 80", jumpToVideoName: nil, goto: 80),
                interBtn2: nil,
                interBtn3: nil,
                displayStart: 52,
                displayEnd: 65,
                chapterToLoop: nil,
                loopActivated: nil),
    Interaction(interactionType: .display,
                id: 4,
                msg: nil,
                interBtn1: InteractionBtn(label: "go 100", jumpToVideoName: nil, goto: 100),
                interBtn2: InteractionBtn(label: "go 150", jumpToVideoName: nil, goto: 150),
                interBtn3: InteractionBtn(label: "go 300", jumpToVideoName: nil, goto: 300),
                displayStart: 70,
                displayEnd: 85,
                chapterToLoop: nil,
                loopActivated: nil),
    Interaction(interactionType: .display,
                id: 5,
                msg: "Ceci est un test de d'affichage de texte sans bouton",
                interBtn1: nil,
                interBtn2: nil,
                interBtn3: nil,
                displayStart: 155,
                displayEnd: 165,
                chapterToLoop: nil,
                loopActivated: nil)
]
