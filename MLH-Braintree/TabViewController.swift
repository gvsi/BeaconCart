//
//  TabViewController.swift
//  MLH-Braintree
//
//  Created by Jessie Serrino on 4/11/15.
//  Copyright (c) 2015 Jessie Serrino. All rights reserved.
//

import UIKit



class TabViewController: UIViewController, UITabBarDelegate, BTDropInViewControllerDelegate {

    @IBOutlet var shopCartView: UIView!
    @IBOutlet var shopTabBar: UITabBar!
    @IBOutlet var tabNavigationBar: UINavigationItem!
    @IBOutlet var shopListView: UIView!
    
    
    var selectedItem: Int!
    
    let manager: AFHTTPRequestOperationManager = AFHTTPRequestOperationManager()
    var braintree : Braintree?
    var transactionID : Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.shopTabBar.delegate = self
        self.shopTabBar.tintColor = UIColor.whiteColor()
        self.shopTabBar.selectedItem = self.shopTabBar.items![0] as! UITabBarItem
        toggleToItem(self.shopTabBar.selectedItem!)
        getToken()
    }

    func getToken() {
        manager.GET("http://brainbeacon.herokuapp.com/get_token",
            parameters: nil,
            success: { (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) -> Void in
                var clientToken = responseObject["clientToken"] as! String
                self.braintree = Braintree(clientToken: clientToken)
                //self.buyButtonPressed.userInteractionEnabled = true
            }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println(error.description)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem!) {
        toggleToItem(item)
    }
    
    func toggleToItem(item: UITabBarItem)
    {
        self.shopCartView.hidden = (item.title == "Shop List")
        self.shopListView.hidden = !self.shopCartView.hidden
        self.tabNavigationBar.title = item.title
    }
    
    
    
    
    @IBAction func buyButtonPressed(sender: AnyObject) {
        
        var dropInViewController: BTDropInViewController = braintree!.dropInViewControllerWithDelegate(self)
        dropInViewController.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Cancel, target: self, action: Selector("userDidCancel"))
        
        //Customize the UI
        dropInViewController.summaryTitle = "Your BeaconCart"
        dropInViewController.summaryDescription = "So much swag!"
        dropInViewController.displayAmount = "$15"
        
        var navigationController: UINavigationController = UINavigationController(rootViewController: dropInViewController)
        
        self.presentViewController(navigationController, animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func postNonce(paymentMethodNonce: String) {
        var parameters = ["payment_method_nonce": paymentMethodNonce, "amount": "15", "number": "+447477460951"]
        
        manager.POST("http://brainbeacon.herokuapp.com/braintree/checkout",
            parameters: parameters,
            success: { (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) -> Void in
                var transactionId = responseObject["transaction"] as! Int
                self.transactionID = transactionId
            }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println("Errorrrrrrrr: \(error.description)")
        }
    }
    
    func userDidCancel() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func dropInViewControllerDidCancel(viewController: BTDropInViewController!) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func dropInViewControllerWillComplete(viewController: BTDropInViewController!) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func dropInViewController(viewController: BTDropInViewController!, didSucceedWithPaymentMethod paymentMethod: BTPaymentMethod!) {
        postNonce(paymentMethod.nonce)
        self.dismissViewControllerAnimated(true, completion: nil)
        
        let view = ModalView.instantiateFromNib("ModalView")
        let window = UIApplication.sharedApplication().delegate?.window!
        let modal = PathDynamicModal()
        modal.showMagnitude = 200.0
        modal.closeMagnitude = 130.0
        view.closeButtonHandler = {[weak modal] in
            UIApplication.sharedApplication().openURL(NSURL(string: "http://brainbeacon.herokuapp.com/payment/\(self.transactionID!)")!)
            modal?.closeWithLeansRandom()
            return
        }
        view.bottomButtonHandler = {[weak modal] in
            modal?.closeWithLeansRandom()
            return
        }
        modal.show(modalView: view, inView: window!)
    }


}
