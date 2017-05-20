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
    let id: String
    let name: String
    let start: Float
    let end: Float
    init(id: String, name: String, start: Float, end: Float) {
        self.id = id
        self.name = name
        self.start = start
        self.end = end
    }
}

var tableChapitre: [Chapitre] = [
    Chapitre(id: "som", name: "sommaire", start: 0, end: 2),
    Chapitre(id: "chap1", name: "chapitre un", start: 2, end: 10),
    Chapitre(id: "chap2", name: "chapitre deux", start: 10, end: 20),
    Chapitre(id: "chap3", name: "chapitre trois", start: 20, end: 30),
    Chapitre(id: "chap4", name: "chapitre quatre", start: 30, end: 40),
    Chapitre(id: "chap5", name: "chapitre cinq", start: 40, end: 50),
    Chapitre(id: "chap6", name: "chapitre six", start: 50, end: 60),
    Chapitre(id: "chap7", name: "chapitre sept", start: 60, end: 70),
    Chapitre(id: "chap8", name: "chapitre huit", start: 70, end: 80),
    Chapitre(id: "chap9", name: "chapitre neuf", start: 80, end: 90),
    Chapitre(id: "chap10", name: "chapitre dix", start: 90, end: 100),
    Chapitre(id: "chap11", name: "chapitre onze", start: 100, end: 110),
    Chapitre(id: "chap12", name: "chapitre douze", start: 110, end: 120)
]

struct InteractionBtn {
    let label: String, jumpToVideoName: String?, goto: Double?, gotoChapterId: String?
    
    init(label: String) { //cet init est utile pour la classe LoopInter
        self.label = label
        self.jumpToVideoName = nil //on reste sur la vidéo courante
        self.goto = nil //si nil, on lance à 0
        self.gotoChapterId = nil
    }
    
    init(label: String, goto: Double) {
        self.label = label
        self.jumpToVideoName = nil //on reste sur la vidéo courante
        self.goto = goto //si nil, on lance à 0
        self.gotoChapterId = nil
    }
    
    init(label: String, jumpToVideoName: String) {
        self.label = label
        self.jumpToVideoName = jumpToVideoName
        self.goto = nil //si nil, on lance à 0
        self.gotoChapterId = nil
    }
    
    init(label: String, gotoChapterId: String) {
        self.label = label
        self.jumpToVideoName = nil //on reste sur la vidéo courante
        self.goto = nil
        self.gotoChapterId = nil
    }
    
    init(label: String, jumpToVideoName: String, gotoChapterId: String) {
        self.label = label
        self.jumpToVideoName = jumpToVideoName //si nil, on reste sur la vidéo courante
        self.goto = nil
        self.gotoChapterId = gotoChapterId
    }
    
    init(label: String, jumpToVideoName: String, goto: Double) {
        self.label = label
        self.jumpToVideoName = jumpToVideoName //si nil, on reste sur la vidéo courante
        self.goto = goto //si nil, on lance à 0
        self.gotoChapterId = nil
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
//le goto se calculera automatiquement à partir de la propriété end de l'objet Chapitre auquel la loop se réfère

class Interaction {
    enum InteractionType { case pause, display, loop, sumary, none }
    var type : InteractionType { //retour InteractionType
        return .none
    }
    let id: Int
    let msg: String?
    let interBtn1: InteractionBtn?
    
    init(id: Int, msg: String?, interBtn1: InteractionBtn?) {
        self.id = id
        self.msg = msg
        self.interBtn1 = interBtn1
    }
}

class LoopInter: Interaction {
    override var type : InteractionType {
        return .loop
    }
    var chapterToLoop: String?
    var loopActivated: Bool = false
    
    init(id: Int, msg: String?, interBtn1:InteractionBtn?, chapterToLoop: String, loopActivated: Bool) {
        
        super.init(id: id, msg: msg, interBtn1: interBtn1)
        self.chapterToLoop = chapterToLoop
        self.loopActivated = loopActivated
    }
}

class PauseInter: Interaction {
    override var type : InteractionType {
        return .pause
    }
    var interBtn2: InteractionBtn?
    var interBtn3: InteractionBtn?
    var displayStart: Float?
    
    init(id: Int, msg: String?, interBtn1: InteractionBtn?, interBtn2: InteractionBtn?, interBtn3: InteractionBtn?, displayStart: Float) {
        
        super.init(id: id, msg: msg, interBtn1: interBtn1)
        self.interBtn2 = interBtn2
        self.interBtn3 = interBtn3
        self.displayStart = displayStart
    }
}

class DisplayInter: PauseInter {
    override var type : InteractionType {
        return .display
    }
    var displayEnd: Float?
    
    init(id: Int, msg: String?, interBtn1: InteractionBtn?, interBtn2: InteractionBtn?, interBtn3: InteractionBtn?, displayStart: Float, displayEnd: Float) {
        
        super.init(id: id, msg: msg, interBtn1: interBtn1, interBtn2: interBtn2, interBtn3: interBtn3, displayStart: displayStart)
        self.displayEnd = displayEnd
    }
}


class SumaryInter: PauseInter {
    override var type: InteractionType {
        return .sumary
    }
    var interBtn4: InteractionBtn?
    var interBtn5: InteractionBtn?
    var interBtn6: InteractionBtn?
    var interBtn7: InteractionBtn?
    var interBtn8: InteractionBtn?
    var interBtn9: InteractionBtn?
    var interBtn10: InteractionBtn?
    var interBtn11: InteractionBtn?
    var interBtn12: InteractionBtn?
    
    init(id: Int, msg: String?, interBtn1: InteractionBtn?, interBtn2: InteractionBtn?, interBtn3: InteractionBtn?,
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
//    SumaryInter(id: 7,
//                msg: "Sommaire",
//                interBtn1: <#T##InteractionBtn?#>,
//                interBtn2: <#T##InteractionBtn?#>,
//                interBtn3: <#T##InteractionBtn?#>,
//                interBtn4: <#T##InteractionBtn#>,
//                interBtn5: <#T##InteractionBtn#>,
//                interBtn6: <#T##InteractionBtn#>,
//                interBtn7: <#T##InteractionBtn#>,
//                interBtn8: <#T##InteractionBtn#>,
//                interBtn9: <#T##InteractionBtn#>,
//                interBtn10: <#T##InteractionBtn#>,
//                interBtn11: <#T##InteractionBtn#>,
//                interBtn12: <#T##InteractionBtn#>,
//                displayStart: 1),
    LoopInter(id: 6,
                msg: "Pressez le bouton pour mettre fin à la boucle",
                interBtn1: InteractionBtn(label: "chapitre suivant"),
                chapterToLoop: "chapitre un",
                loopActivated: true),
    PauseInter(id: 1,
                msg: "Presser l'un des boutons !",
                interBtn1: InteractionBtn(label: "Disney", jumpToVideoName: "Disney"),
                interBtn2: InteractionBtn(label: "go 60", goto: 60),
                interBtn3: nil,
                displayStart: 13),
    PauseInter(id: 2,
                msg: nil,
                interBtn1: InteractionBtn(label: "go 30", goto: 50),
                interBtn2: InteractionBtn(label: "go 65", goto: 65),
                interBtn3: InteractionBtn(label: "go 250", goto: 250),
                displayStart: 20),
    DisplayInter(id: 3,
                msg: "Presser le bouton avant qu'il ne disparaisse...",
                interBtn1: InteractionBtn(label: "go 80", goto: 80),
                interBtn2: nil,
                interBtn3: nil,
                displayStart: 52,
                displayEnd: 65),
    DisplayInter(id: 4,
                msg: nil,
                interBtn1: InteractionBtn(label: "go 100", goto: 100),
                interBtn2: InteractionBtn(label: "go 150", goto: 150),
                interBtn3: InteractionBtn(label: "go 300", goto: 300),
                displayStart: 70,
                displayEnd: 85),
    DisplayInter(id: 5,
                msg: "Ceci est un test de d'affichage de texte sans bouton",
                interBtn1: nil,
                interBtn2: nil,
                interBtn3: nil,
                displayStart: 155,
                displayEnd: 165)
]
