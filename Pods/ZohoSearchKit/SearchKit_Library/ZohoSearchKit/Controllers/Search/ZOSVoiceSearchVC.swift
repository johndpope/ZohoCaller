//
//  ZOSVoiceSearchVC.swift
//  ZohoSearchKit
//
//  Created by manikandan bangaru on 22/06/18.
//

import UIKit
import Speech
enum SpeechStatus {
    case ready
    case recognizing
    case unavailable
}
@available(iOS 10.0, *)
class ZOSVoiceSearchVC: UIViewController , SFSpeechRecognizerDelegate {
    @IBOutlet weak var textDisplay: UITextField!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var ZOSActivityIndicator : ZOSActivityIndicatorView!
    var status : SpeechStatus = .unavailable
    let audioEngine = AVAudioEngine()
    let speechRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer()
    let request : SFSpeechAudioBufferRecognitionRequest =
    {
        let req = SFSpeechAudioBufferRecognitionRequest()
        req.taskHint = .search
        //NOTE:- An array of phrases that should be recognized, even if they are not in the system vocabulary.
        req.contextualStrings = ["hemant Singh" , "arun kumar","mohan sai","Hari Krishnan","Harish Kumar","Zoho","arun","vijaya"]
        return req
    }()
    var recognitionTask: SFSpeechRecognitionTask?
    
    static func vcInstanceFromStoryboard() -> ZOSVoiceSearchVC? {
        let storyboard = UIStoryboard(name: "SearchKit_" + String(describing: ZOSVoiceSearchVC.self), bundle: ZohoSearchKit.frameworkBundle)
        return storyboard.instantiateInitialViewController() as? ZOSVoiceSearchVC
    }
    @IBAction func closeButtonPressed(_ sender: Any) {
        let parentVC = self.getParentViewController()
        parentVC?.remove(childViewController: self)
    }
    override func viewWillAppear(_ animated: Bool) {
        switch SFSpeechRecognizer.authorizationStatus() {
        case .notDetermined:
            SFSpeechRecognizer.requestAuthorization { status in
                OperationQueue.main.addOperation {
                    switch status {
                    case .authorized:
                        self.status = .ready
                    case .denied ,.restricted:
                        self.status = .unavailable
                        self.alertForGrandingPremission()
                    default:
                        self.status = .unavailable
                    }
                }
            }
        case .authorized:
            self.status = .ready
        case .denied, .restricted:
            self.status = .unavailable
            self.alertForGrandingPremission()
        }
        switch AVAudioSession.sharedInstance().recordPermission() {
        case .denied:
            self.alertForGrandingPremission()
        case .undetermined:
            AVAudioSession.sharedInstance().requestRecordPermission({ (granted) in
                if !granted
                {
                   self.alertForGrandingPremission()
                }
            })
        default:
            break
        }
    }
    func alertForGrandingPremission()
    {
       
                var alertText = "It looks like your privacy settings are preventing us from accessing Mic and Speech Recognition to do Voice Search. You can fix this by doing the following:\n\n1. Close this app.\n\n2. Open the Settings app.\n\n3. Scroll to the bottom and select this app in the list.\n\n4. Turn the Mic and Speech Recognition on.\n\n5. Open this app and try again."
                var alertButton = "OK"
                var goAction = UIAlertAction(title: alertButton, style: .default, handler: nil)
                
                if UIApplication.shared.canOpenURL(URL(string: UIApplicationOpenSettingsURLString)!)
                {
                    alertText = "It looks like your privacy settings are preventing us from accessing Mic and Speech Recognition to do voice Search. You can fix this by doing the following:\n\n1. Touch the Go button below to open the Settings app.\n\n2. Turn the Mic and Speech Recognition on.\n\n3. Open this app and try again."
                    alertButton = "Go"
                    
                    goAction = UIAlertAction(title: alertButton, style: .default, handler: {(alert: UIAlertAction!) -> Void in
                        UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!, options: [:], completionHandler: nil)
                    })
                }
                let alert = UIAlertController(title: "Permission Required", message: alertText, preferredStyle: .alert)
                alert.addAction(goAction)
                self.present(alert, animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        ZOSActivityIndicator.startAnimating()
        status = .recognizing
        self.view.layer.shadowRadius = 0.1
        self.view.layer.shadowOpacity = 0.5
        self.view.layer.shadowColor = UIColor.darkGray.cgColor
        startVoiceRecording()
    }
    
    func cancelRecording() {
        audioEngine.stop()
        request.endAudio()
        let node = audioEngine.inputNode
        node.removeTap(onBus: 0)
        recognitionTask?.cancel()
    }
    @IBAction func microphonePressed() {
        switch status {
        case .ready:
            startVoiceRecording()
            status = .recognizing
        case .recognizing:
            cancelRecording()
            status = .ready
        default:
            break
        }
    }
    func restartSpeechTimer() {
        detectTimer?.invalidate()
        detectTimer = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false, block: { (timer) in
            self.stopTimer()
        })
    }
    func stopTimer()
    {
        cancelRecording()
        detectTimer?.invalidate()
        detectTimer = nil
        detectTimer?.invalidate()
        if let parentVC = self.getParentViewController() as? SearchQueryViewController
        {
            _ = parentVC.textFieldShouldReturn(parentVC.searchbar)
        }
        self.closeButtonPressed(closeButton)
    }
    var detectTimer : Timer?
    func  startVoiceRecording()
    {
        //set up for the audio engine and speech recognizer
        let node = audioEngine.inputNode
        let recordingFormat = audioEngine.inputNode.outputFormat(forBus: 0)
        node.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat){
            buffer, _ in
            self.request.append(buffer)
        }
        //start the recording
        audioEngine.prepare()
        do{
            try audioEngine.start()
        }
        catch{
            // error
        }
        //MARK:- make sure the recognizer is available for the device and for the locale
        guard  let myReconizer = SFSpeechRecognizer() else {
            return
        }
        if !myReconizer.isAvailable{
            return
        }
        //configuring  our audio session
        let audioSession = AVAudioSession.sharedInstance()
        try? audioSession.setCategory(AVAudioSessionCategoryRecord)
        try? audioSession.setMode(AVAudioSessionModeMeasurement)
        try? audioSession.setActive(true, with: .notifyOthersOnDeactivation)

        recognitionTask = speechRecognizer?.recognitionTask(with: request, resultHandler: {
            result , error in
            if let _ = error{
                self.closeButtonPressed(self.closeButton)
            }
            guard let result = result else{return}
            let resultText = result.bestTranscription.formattedString
            //            self.textDisplay.text = resultText
            if let parentVC = self.getParentViewController() as? SearchQueryViewController
            {
                parentVC.searchbar.text = resultText
                parentVC.searchbar.textDidChanged(newText: resultText)
            }
            var isFinal = false
            isFinal = result.isFinal
            if isFinal {
                self.stopTimer()
            }
            else if error == nil {
                self.restartSpeechTimer()
            }
           
        })
    }
}
