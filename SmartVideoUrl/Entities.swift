//
//  Entities.swift
//  SmartVideo
//
//  Created by Serge Sahaguian on 08/04/2017.
//  Copyright © 2017 Serge Sahaguian. All rights reserved.
//

import Foundation

enum OperatorType { case goBack, goForward }

struct Video {
    let nameId: String
    let name: String
    let url: URL
    init(nameId: String, name: String, url: URL!) {
        self.nameId = nameId
        self.name = name
        self.url = url
    }
}

var tableVideos: [Video] = [
    Video(nameId: "vid1", name: "La chasse aux lions", url: URL(string: "http://www.schlum.com/myr/arte.mp4")),
    Video(nameId: "vid2", name: "Toy Story", url: URL(string: "http://www.html5videoplayer.net/videos/toystory.mp4"))
]

struct Chapitre {
    let id: String
    let chapterName: String
    let videoNameId: String
    let start: Float
    let end: Float
    init(id: String, chapterName: String, videoNameId:String, start: Float, end: Float) {
        self.id = id
        self.chapterName = chapterName
        self.videoNameId = videoNameId
        self.start = start
        self.end = end
    }
}

var tableChapitres: [Chapitre] = [
    Chapitre(id: "som", chapterName: "sommaire", videoNameId: "vid1" ,start: 0, end: 2),
    Chapitre(id: "chap1", chapterName: "chapitre un", videoNameId: "vid1", start: 2, end: 10),
    Chapitre(id: "chap2", chapterName: "chapitre deux", videoNameId: "vid1", start: 10, end: 20),
    Chapitre(id: "chap3", chapterName: "chapitre trois", videoNameId: "vid1", start: 20, end: 30),
    Chapitre(id: "chap4", chapterName: "chapitre quatre", videoNameId: "vid1", start: 30, end: 40),
    Chapitre(id: "chap5", chapterName: "chapitre cinq", videoNameId: "vid1", start: 40, end: 50),
    Chapitre(id: "chap6", chapterName: "chapitre six", videoNameId: "vid1", start: 50, end: 60),
    Chapitre(id: "chap7", chapterName: "chapitre sept", videoNameId: "vid1", start: 60, end: 70),
    Chapitre(id: "chap8", chapterName: "chapitre huit", videoNameId: "vid1", start: 70, end: 80),
    Chapitre(id: "chap9", chapterName: "chapitre neuf", videoNameId: "vid1", start: 80, end: 90),
    Chapitre(id: "chap10", chapterName: "chapitre dix", videoNameId: "vid1", start: 90, end: 100),
    Chapitre(id: "chap11", chapterName: "chapitre onze", videoNameId: "vid1", start: 100, end: 110),
    Chapitre(id: "chap12", chapterName: "chapitre douze", videoNameId: "vid1", start: 110, end: 120)
]

struct InteractionBtn {
    let label: String
    let gotoChapterId: String?
    var jumpToVideoNameId: String?, goto: Double?
    
    init(label: String) { //cet init est utile pour la classe LoopInter
        self.label = label
        self.jumpToVideoNameId = nil //on reste sur la vidéo courante
        self.goto = nil //si nil, on lance à 0
        self.gotoChapterId = nil
    }
    
    init(label: String, goto: Double) {
        self.label = label
        self.jumpToVideoNameId = nil //on reste sur la vidéo courante
        self.goto = goto //si nil, on lance à 0
        self.gotoChapterId = nil
    }
    
    init(label: String, jumpToVideoNameId: String) {
        self.label = label
        self.jumpToVideoNameId = jumpToVideoNameId
        self.goto = nil //si nil, on lance à 0
        self.gotoChapterId = nil
    }
    
    //pour l'initialisation ci dessous, on indique juste le chapitre cible
    //on va déterminer jumpToVideoNameId et goto dynamiquement en consuultant tableChapitres
    init(label: String, gotoChapterId: String) {
        self.label = label
        self.gotoChapterId = gotoChapterId
        self.jumpToVideoNameId = nil
        self.goto = nil
        for chapter in tableChapitres {
            if chapter.id == gotoChapterId {
                self.jumpToVideoNameId = chapter.videoNameId
                self.goto = Double(chapter.start)
            }
        }
    }
    
    init(label: String, jumpToVideoNameId: String, goto: Double) {
        self.label = label
        self.jumpToVideoNameId = jumpToVideoNameId //si nil, on reste sur la vidéo courante
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
    let videoNameId: String
    let msg: String?
    let interBtn1: InteractionBtn?
    
    init(id: Int, videoNameId: String, msg: String?, interBtn1: InteractionBtn?) {
        self.id = id
        self.videoNameId = videoNameId
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
    
    init(id: Int, videoNameId: String, msg: String?, interBtn1:InteractionBtn?, chapterToLoop: String, loopActivated: Bool) {
        
        super.init(id: id, videoNameId: videoNameId, msg: msg, interBtn1: interBtn1)
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
    
    init(id: Int, videoNameId: String, msg: String?, interBtn1: InteractionBtn?, interBtn2: InteractionBtn?, interBtn3: InteractionBtn?, displayStart: Float) {
        
        super.init(id: id, videoNameId: videoNameId, msg: msg, interBtn1: interBtn1)
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
    
    init(id: Int, videoNameId: String, msg: String?, interBtn1: InteractionBtn?, interBtn2: InteractionBtn?, interBtn3: InteractionBtn?, displayStart: Float, displayEnd: Float) {
        
        super.init(id: id, videoNameId: videoNameId, msg: msg, interBtn1: interBtn1, interBtn2: interBtn2, interBtn3: interBtn3, displayStart: displayStart)
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
    
    init(id: Int, videoNameId: String, msg: String?, interBtn1: InteractionBtn?, interBtn2: InteractionBtn?, interBtn3: InteractionBtn?,
         interBtn4: InteractionBtn, interBtn5: InteractionBtn, interBtn6: InteractionBtn, interBtn7: InteractionBtn,
         interBtn8: InteractionBtn, interBtn9: InteractionBtn, interBtn10: InteractionBtn, interBtn11: InteractionBtn,
         interBtn12: InteractionBtn, displayStart: Float) {

        super.init(id: id, videoNameId: videoNameId ,msg: msg, interBtn1: interBtn1, interBtn2: interBtn2, interBtn3: interBtn3, displayStart: displayStart)
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

var tableInteractions: [Interaction] = [
    SumaryInter(id: 7,
                videoNameId: "vid1",
                msg: "Sommaire",
                interBtn1: InteractionBtn(label: "chapitre 1", gotoChapterId: "chap1"),
                interBtn2: InteractionBtn(label: "capitre 2", gotoChapterId: "chap2"),
                interBtn3: InteractionBtn(label: "chapitre 3", gotoChapterId: "chap3"),
                interBtn4: InteractionBtn(label: "chapitre 4", gotoChapterId: "chap4"),
                interBtn5: InteractionBtn(label: "chapitre 5", gotoChapterId: "chap5"),
                interBtn6: InteractionBtn(label: "chapitre 6", gotoChapterId: "chap6"),
                interBtn7: InteractionBtn(label: "chapitre 7", gotoChapterId: "chap7"),
                interBtn8: InteractionBtn(label: "chapitre 8", gotoChapterId: "chap8"),
                interBtn9: InteractionBtn(label: "chapitre 9", gotoChapterId: "chap9"),
                interBtn10: InteractionBtn(label: "chapitre 10", gotoChapterId: "chap10"),
                interBtn11: InteractionBtn(label: "chapitre 11", gotoChapterId: "chap11"),
                interBtn12: InteractionBtn(label: "chapitre 12", gotoChapterId: "chap12"),
                displayStart: 1),
    LoopInter(id: 6,
                videoNameId: "vid1",
                msg: "Pressez le bouton pour mettre fin à la boucle",
                interBtn1: InteractionBtn(label: "chapitre suivant"),
                chapterToLoop: "chapitre un",
                loopActivated: true),
    PauseInter(id: 1,
                videoNameId: "vid1",
                msg: "Presser l'un des boutons !",
                interBtn1: InteractionBtn(label: "Toy Story", jumpToVideoNameId: "vid2"),
                interBtn2: InteractionBtn(label: "go 60", goto: 60),
                interBtn3: nil,
                displayStart: 13),
    PauseInter(id: 2,
                videoNameId: "vid1",
                msg: nil,
                interBtn1: InteractionBtn(label: "go 30", goto: 50),
                interBtn2: InteractionBtn(label: "go 65", goto: 65),
                interBtn3: InteractionBtn(label: "go 250", goto: 250),
                displayStart: 20),
    DisplayInter(id: 3,
                videoNameId: "vid1",
                msg: "Presser le bouton avant qu'il ne disparaisse...",
                interBtn1: InteractionBtn(label: "go 80", goto: 80),
                interBtn2: nil,
                interBtn3: nil,
                displayStart: 52,
                displayEnd: 65),
    DisplayInter(id: 4,
                videoNameId: "vid1",
                msg: nil,
                interBtn1: InteractionBtn(label: "go 100", goto: 100),
                interBtn2: InteractionBtn(label: "go 150", goto: 150),
                interBtn3: InteractionBtn(label: "go 300", goto: 300),
                displayStart: 70,
                displayEnd: 85),
    DisplayInter(id: 5,
                videoNameId: "vid1",
                msg: "Ceci est un test de d'affichage de texte sans bouton",
                interBtn1: nil,
                interBtn2: nil,
                interBtn3: nil,
                displayStart: 155,
                displayEnd: 165)
]
