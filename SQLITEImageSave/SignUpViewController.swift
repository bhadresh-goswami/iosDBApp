//
//  SignUpViewController.swift
//  SQLITEImageSave
//
//  Created by COE-18 on 03/01/20.
//  Copyright © 2020 bSquareG. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController, UIPickerViewDelegate,
UIPickerViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate{
   
    @IBOutlet weak var pickerCity: UIPickerView!
    @IBOutlet weak var txtEmailId: UITextField!
    @IBOutlet weak var txtUserNAme: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var segGender: UISegmentedControl!
    @IBOutlet weak var imgUser: UIImageView!
    
    var db:dbManage!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        db = dbManage()
        
        cityData = db.RunQuery(query: "SELECT * FROM tblCities ORDER BY cityname")
        pickerCity.reloadComponent(0)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var cityData = [[String:Any]]()
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return cityData.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return (cityData[row]["cityname"] as! String)
    }

    var cityName = ""
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        cityName = (cityData[row]["cityname"] as! String)
    }

    var imgPicker:UIImagePickerController!
    @IBAction func PickImageOnTapAction(_ sender: UITapGestureRecognizer) {
    
        imgPicker = UIImagePickerController()
        imgPicker.sourceType = .photoLibrary
        
        
        imgPicker.delegate = self
    
        //self.navigationController?.pushViewController(imgPicker, animated: true)
        self.present(imgPicker, animated: true, completion: nil)
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let img = info[UIImagePickerControllerOriginalImage] as! UIImage
        imgUser.image = img
        
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        //self.navigationController?.popViewController(animated: true)//.pop(animated: true, completion: nil)
        self.dismiss(animated: true, completion: nil)
    }
    
    var arrGender = ["Male","Female","Other"]
    @IBAction func btnSaveAction(_ sender: UIButton) {
        
        let Gender = arrGender[segGender.selectedSegmentIndex]
        
        let imgData = UIImageJPEGRepresentation(imgUser.image!,1.0)
        
        let cmd = "INSERT INTO tblinfo (name,emailid,cityname,gender,password,image) VALUES('\(txtUserNAme.text!)','\(txtEmailId.text!)','\(cityName)','\(Gender)','\(txtPassword.text!)','\(imgData!)')"
        
        if db.RunCommand(cmd: cmd)
        {
            print("Data Saved!")
        }
        else{
            print("Not Saved!")
        }
        
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
