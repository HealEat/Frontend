// Copyright © 2025 HealEat. All rights reserved.

import UIKit
import Kingfisher

struct dummyModel {
    let storeimage: String
    let storename: String
    let foodname: String
    let scrapimage: String
    let starimage: String
    let totalscore: String
    let scorelist: String
    let foodtag: String
}



extension dummyModel {
    static func storedummy() -> [dummyModel] {
        return [
            dummyModel(storeimage: "https://s3-alpha-sig.figma.com/img/c92b/8627/77ce879fa13368c71be6520d8a803ec8?Expires=1739145600&Key-Pair-Id=APKAQ4GOSFWCW27IBOMQ&Signature=Rw-eZvutHn5qlZgPt0KvZttAaN3vLVZahdXs3TloM-c1ir04JZ9aP-HxbsPg92ME66fkUCprDb23Iq0recwcog3N0TD1lJFM-VdcgH~IBsz36j6CgBEyvN2uvL7fBSFRSDpvyCns5jNLb5lTWq-rpLP8DJ7fijxRMQS51U6169TJ1saf8CuEmd26zEOEo-CcrMoRWzLl7kmLdjOi3SPMQc7yoXUNj0IGfM5UxgFAOrdL~R3sO1Dyv4R3lx0nmghIaI3DyNmTYpp6xdFitwpp4lBA-kVP5N9tVkdgj0RaidauR-FcUaZAb682gOe9vASYMievsVtbMwbiNu446OlCnQ__", storename: "본죽&비빔밥cafe 홍대점", foodname: "죽", scrapimage: "scrapimage.png", starimage: "starimage.png", totalscore: "4.0 (23)", scorelist: "별점 리스트.png", foodtag: "foodtag.png"),
            dummyModel(storeimage: "https://s3-alpha-sig.figma.com/img/c92b/8627/77ce879fa13368c71be6520d8a803ec8?Expires=1739145600&Key-Pair-Id=APKAQ4GOSFWCW27IBOMQ&Signature=Rw-eZvutHn5qlZgPt0KvZttAaN3vLVZahdXs3TloM-c1ir04JZ9aP-HxbsPg92ME66fkUCprDb23Iq0recwcog3N0TD1lJFM-VdcgH~IBsz36j6CgBEyvN2uvL7fBSFRSDpvyCns5jNLb5lTWq-rpLP8DJ7fijxRMQS51U6169TJ1saf8CuEmd26zEOEo-CcrMoRWzLl7kmLdjOi3SPMQc7yoXUNj0IGfM5UxgFAOrdL~R3sO1Dyv4R3lx0nmghIaI3DyNmTYpp6xdFitwpp4lBA-kVP5N9tVkdgj0RaidauR-FcUaZAb682gOe9vASYMievsVtbMwbiNu446OlCnQ__", storename: "본죽&비빔밥cafe 홍대점", foodname: "죽", scrapimage: "scrapimage.png", starimage: "starimage.png", totalscore: "4.0 (23)", scorelist: "별점 리스트.png", foodtag: "foodtag.png"),
            dummyModel(storeimage: "https://s3-alpha-sig.figma.com/img/c92b/8627/77ce879fa13368c71be6520d8a803ec8?Expires=1739145600&Key-Pair-Id=APKAQ4GOSFWCW27IBOMQ&Signature=Rw-eZvutHn5qlZgPt0KvZttAaN3vLVZahdXs3TloM-c1ir04JZ9aP-HxbsPg92ME66fkUCprDb23Iq0recwcog3N0TD1lJFM-VdcgH~IBsz36j6CgBEyvN2uvL7fBSFRSDpvyCns5jNLb5lTWq-rpLP8DJ7fijxRMQS51U6169TJ1saf8CuEmd26zEOEo-CcrMoRWzLl7kmLdjOi3SPMQc7yoXUNj0IGfM5UxgFAOrdL~R3sO1Dyv4R3lx0nmghIaI3DyNmTYpp6xdFitwpp4lBA-kVP5N9tVkdgj0RaidauR-FcUaZAb682gOe9vASYMievsVtbMwbiNu446OlCnQ__", storename: "본죽&비빔밥cafe 홍대점", foodname: "죽", scrapimage: "scrapimage.png", starimage: "starimage.png", totalscore: "4.0 (23)", scorelist: "별점 리스트.png", foodtag: "foodtag.png")
        ]
    }
}
