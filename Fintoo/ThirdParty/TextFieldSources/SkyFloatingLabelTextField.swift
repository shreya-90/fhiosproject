//  Copyright 2016 Skyscanner Ltd
//
//  Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.

import UIKit

@IBDesignable
open class SkyFloatingLabelTextField: UITextField,UITextFieldDelegate
{
    /// A Boolean value that determines if the language displayed is LTR. Default value set automatically from the application language settings.
    var isLTRLanguage = UIApplication.shared.userInterfaceLayoutDirection == .leftToRight {
        didSet {
           self.updateTextAligment()
        }
    }
    
    fileprivate func updateTextAligment() {
        if(self.isLTRLanguage) {
            self.textAlignment = .left
        } else {
            self.textAlignment = .right
        }
    }
    
    // MARK: Animation timing
    
    /// The value of the title appearing duration
    open var titleFadeInDuration:TimeInterval = 0.2
    /// The value of the title disappearing duration
    open var titleFadeOutDuration:TimeInterval = 0.3
    
    // MARK: Colors
    
    fileprivate var cachedTextColor:UIColor?
    
    /// A UIColor value that determines the text color of the editable text
    @IBInspectable
    override open var textColor:UIColor?
        {
        set {
            self.cachedTextColor = newValue
            self.updateControl(false)
        }
        get {
            return cachedTextColor
        }
    }
    
    /// A UIColor value that determines text color of the placeholder label
    @IBInspectable open var placeholderColor:UIColor = UIColor.lightGray {
        didSet {
            self.updatePlaceholder()
        }
    }

    /// A UIColor value that determines text color of the placeholder label
    @IBInspectable open var placeholderFont:UIFont? {
        didSet {
            self.updatePlaceholder()
        }
    }
    
    fileprivate func updatePlaceholder() {
        if let
            placeholder = self.placeholder,
            let font = self.placeholderFont ?? self.font {
            self.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedStringKey.foregroundColor:placeholderColor,NSAttributedStringKey.font: font])
        }
    }

    /// A UIColor value that determines the text color of the title label when in the normal state
    @IBInspectable open var titleColor:UIColor = UIColor.gray {
        didSet {
            self.updateTitleColor()
        }
    }
    
    /// A UIColor value that determines the color of the bottom line when in the normal state
    @IBInspectable open var lineColor:UIColor = UIColor.lightGray {
        didSet {
            self.updateLineView()
        }
    }
    
    /// A UIColor value that determines the color used for the title label and the line when the error message is not `nil`
    @IBInspectable open var errorColor:UIColor = UIColor.red {
        didSet {
            self.updateColors()
        }
    }
    
    /// A UIColor value that determines the text color of the title label when editing
    @IBInspectable open var selectedTitleColor:UIColor = UIColor.blue {
        didSet {
            self.updateTitleColor()
        }
    }
    
    /// A UIColor value that determines the color of the line in a selected state
    @IBInspectable open var selectedLineColor:UIColor = UIColor.black {
        didSet {
            self.updateLineView()
        }
    }
    
    // MARK: Line height
    
    /// A CGFloat value that determines the height for the bottom line when the control is in the normal state
    @IBInspectable open var lineHeight:CGFloat = 0.5 {
        didSet {
            self.updateLineView()
            self.setNeedsDisplay()
        }
    }
    
    /// A CGFloat value that determines the height for the bottom line when the control is in a selected state
    @IBInspectable open var selectedLineHeight:CGFloat = 1.0 {
        didSet {
            self.updateLineView()
            self.setNeedsDisplay()
        }
    }
    
    // MARK: View components
    
    /// The internal `UIView` to display the line below the text input.
    open var lineView:UIView!
    
    /// The internal `UILabel` that displays the selected, deselected title or the error message based on the current state.
    open var titleLabel:UILabel!
    
    // MARK: Properties
    
    /**
    The formatter to use before displaying content in the title label. This can be the `title`, `selectedTitle` or the `errorMessage`.
    The default implementation converts the text to uppercase.
    */
    open var titleFormatter:((String) -> String) = { (text:String) -> String in
        return text//.uppercaseString
    }
    
    /**
     Identifies whether the text object should hide the text being entered.
     */
    override open var isSecureTextEntry:Bool {
        set {
            super.isSecureTextEntry = newValue
            self.fixCaretPosition()
        }
        get {
            return super.isSecureTextEntry
        }
    }
    
    /// A String value for the error message to display.
    open var errorMessage:String? {
        didSet {
            self.updateControl(true)
        }
    }
    
    /// The backing property for the highlighted property
    fileprivate var _highlighted = false
    
    /// A Boolean value that determines whether the receiver is highlighted. When changing this value, highlighting will be done with animation
    override open var isHighlighted:Bool {
        get {
            return _highlighted
        }
        set {
            _highlighted = newValue
            self.updateTitleColor()
            self.updateLineView()
        }
    }

    /// A Boolean value that determines whether the textfield is being edited or is selected.
    open var editingOrSelected:Bool {
        get {
            return super.isEditing || self.isSelected;
        }
    }
    
    /// A Boolean value that determines whether the receiver has an error message.
    open var hasErrorMessage:Bool {
        get {
            return self.errorMessage != nil && self.errorMessage != ""
        }
    }

    fileprivate var _renderingInInterfaceBuilder:Bool = false
    
    /// The text content of the textfield
    @IBInspectable
    override open var text:String? {
        didSet {
            self.updateControl(false)
        }
    }
    
    /**
     The String to display when the input field is empty.
     The placeholder can also appear in the title label when both `title` `selectedTitle` and are `nil`.
     */
    @IBInspectable
    override open var placeholder:String? {
        didSet {
            self.setNeedsDisplay()
            self.updatePlaceholder()
            self.updateTitleLabel()
        }
    }
    
    /// The String to display when the textfield is editing and the input is not empty.
    @IBInspectable open var selectedTitle:String? {
        didSet {
            self.updateControl()
        }
    }
    
    /// The String to display when the textfield is not editing and the input is not empty.
    @IBInspectable open var title:String? {
        didSet {
            self.updateControl()
        }
    }
    
    // Determines whether the field is selected. When selected, the title floats above the textbox.
    open override var isSelected:Bool {
        didSet {
            self.updateControl(true)
        }
    }
    
    @IBInspectable var isLine: Bool = false{
        didSet {
            islineSet()
//            self.updateControl(true)
        }
    }// = false   /**< Default is False*/

    // MARK: - Initializers
    
    /**
    Initializes the control
    - parameter frame the frame of the control
    */
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.init_SkyFloatingLabelTextField()
        self.textFieldValidatorSetup()
    }
    
    /**
     Intialzies the control by deserializing it
     - parameter coder the object to deserialize the control from
     */
    required public init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        self.init_SkyFloatingLabelTextField()
        self.textFieldValidatorSetup()
    }
    
    fileprivate final func init_SkyFloatingLabelTextField()
    {
        if isLine {
            self.borderStyle = .none
        }
        self.createTitleLabel()
        self.createLineView()
        self.updateColors()
        self.addEditingChangedObserver()
        self.updateTextAligment()
    }
    
    fileprivate func addEditingChangedObserver() {
        self.addTarget(self, action: #selector(SkyFloatingLabelTextField.editingChanged), for: .editingChanged)
    }
    
    /**
     Invoked when the editing state of the textfield changes. Override to respond to this change.
     */
    @objc open func editingChanged() {
        updateControl(true)
        updateTitleLabel(true)
    }
    
    fileprivate func islineSet()
    {
        if isLine {
            self.borderStyle = .none
        }
        createLineView();
        createTitleLabel();
    }
    
    // MARK: create components
    
    fileprivate func createTitleLabel()
    {
        let titleLabel = UILabel()
        titleLabel.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        titleLabel.font = UIFont.systemFont(ofSize: 13)
        titleLabel.alpha = 0.0
        titleLabel.textColor = self.titleColor
        if isLine {
            self.addSubview(titleLabel)
        }
        self.titleLabel = titleLabel
    }
    
    fileprivate func createLineView() {
        
        if self.lineView == nil
        {
            let lineView = UIView()
            lineView.isUserInteractionEnabled = false
            self.lineView = lineView
            self.configureDefaultLineHeight()
        }
        lineView.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
        if isLine {
            self.addSubview(lineView)
        }
    }
    
    fileprivate func configureDefaultLineHeight() {
        let onePixel:CGFloat = 1.0 / UIScreen.main.scale
        self.lineHeight = 2.0 * onePixel
        self.selectedLineHeight = 2.0 * self.lineHeight
    }
    
    // MARK: Responder handling
    
    /**
     Attempt the control to become the first responder
     - returns: True when successfull becoming the first responder
    */
    override open func becomeFirstResponder() -> Bool {
        let result = super.becomeFirstResponder()
        self.updateControl(true)
        return result
    }
    
    /**
     Attempt the control to resign being the first responder
     - returns: True when successfull resigning being the first responder
     */
    override open func resignFirstResponder() -> Bool {
        let result =  super.resignFirstResponder()
        self.updateControl(true)
        return result
    }
    
    // MARK: - View updates
    
    fileprivate func updateControl(_ animated:Bool = false) {
        self.updateColors()
        self.updateLineView()
        self.updateTitleLabel(animated)
    }
    
    fileprivate func updateLineView() {
        if let lineView = self.lineView {
            lineView.frame = self.lineViewRectForBounds(self.bounds, editing: self.editingOrSelected)
        }
        self.updateLineColor()
    }
    
    // MARK: - Color updates
    
    /// Update the colors for the control. Override to customize colors.
    open func updateColors()
    {
        self.updateLineColor()
        self.updateTitleColor()
        self.updateTextColor()
    }
    
    fileprivate func updateLineColor() {
        if self.hasErrorMessage {
            self.lineView.backgroundColor = self.errorColor
        } else {
            self.lineView.backgroundColor = self.editingOrSelected ? self.selectedLineColor : self.lineColor
        }
    }
    
    fileprivate func updateTitleColor() {
        if self.hasErrorMessage {
            self.titleLabel.textColor = self.errorColor
        } else {
            if self.editingOrSelected || self.isHighlighted {
                self.titleLabel.textColor = self.selectedTitleColor
            } else {
                self.titleLabel.textColor = self.titleColor
            }
        }
    }
    
    fileprivate func updateTextColor() {
        if self.hasErrorMessage {
            super.textColor = self.errorColor
        } else {
            super.textColor = self.cachedTextColor
        }
    }
    
    // MARK: - Title handling
    
    fileprivate func updateTitleLabel(_ animated:Bool = false) {
        
        var titleText:String? = nil
        if self.hasErrorMessage {
            titleText = self.titleFormatter(errorMessage!)
        } else {
            if self.editingOrSelected {
                titleText = self.selectedTitleOrTitlePlaceholder()
                if titleText == nil {
                    titleText = self.titleOrPlaceholder()
                }
            } else {
                titleText = self.titleOrPlaceholder()
            }
        }
        self.titleLabel.text = titleText
        
        self.updateTitleVisibility(animated)
    }
    
    fileprivate var _titleVisible = false
    
    /*
    *   Set this value to make the title visible
    */
    open func setTitleVisible(_ titleVisible:Bool, animated:Bool = false, animationCompletion: (()->())? = nil) {
        if(_titleVisible == titleVisible) {
            return
        }
        _titleVisible = titleVisible
        self.updateTitleColor()
        self.updateTitleVisibility(animated, completion: animationCompletion)
    }
    
    /**
     Returns whether the title is being displayed on the control.
     - returns: True if the title is displayed on the control, false otherwise.
     */
    open func isTitleVisible() -> Bool {
        return self.hasText || self.hasErrorMessage || _titleVisible
    }
    
    fileprivate func updateTitleVisibility(_ animated:Bool = false, completion: (()->())? = nil) {
        let alpha:CGFloat = self.isTitleVisible() ? 1.0 : 0.0
        let frame:CGRect = self.titleLabelRectForBounds(self.bounds, editing: self.isTitleVisible())
        let updateBlock = { () -> Void in
            self.titleLabel.alpha = alpha
            self.titleLabel.frame = frame
        }
        if animated {
            let animationOptions:UIViewAnimationOptions = .curveEaseOut;
            let duration = self.isTitleVisible() ? titleFadeInDuration : titleFadeOutDuration
            
            UIView.animate(withDuration: duration, delay: 0, options: animationOptions, animations: { () -> Void in
                updateBlock()
                }, completion: { _ in
                    completion?()
                })
        } else {
            updateBlock()
            completion?()
        }
    }
    
    // MARK: - UITextField text/placeholder positioning overrides
    
    /** 
    Calculate the rectangle for the textfield when it is not being edited
    - parameter bounds: The current bounds of the field
    - returns: The rectangle that the textfield should render in
    */
    override open func textRect(forBounds bounds: CGRect) -> CGRect
    {
        super.textRect(forBounds: bounds)
        if isLine {
            let titleHeight = self.titleHeight()
            let lineHeight = self.selectedLineHeight
            let pading = self.rightViewRect(forBounds: bounds).size.width+rightInset + rightInset + self.leftViewRect(forBounds: bounds).size.width + leftInset + leftInset
            let rect = CGRect(x: self.leftViewRect(forBounds: bounds).size.width + leftInset+leftInset, y: titleHeight, width: bounds.size.width-pading, height: bounds.size.height - titleHeight - lineHeight)//.insetBy(dx: inset, dy: inset)
            return rect
        }
        let pading = self.rightViewRect(forBounds: bounds).size.width+rightInset + rightInset + self.leftViewRect(forBounds: bounds).size.width + leftInset + leftInset
        let rect = CGRect(x: self.leftViewRect(forBounds: bounds).size.width + leftInset+leftInset, y: 0, width: bounds.size.width-pading, height: bounds.size.height )//.insetBy(dx: inset, dy: inset)
        return rect

    }
    
    /**
     Calculate the rectangle for the textfield when it is being edited
     - parameter bounds: The current bounds of the field
     - returns: The rectangle that the textfield should render in
     */
    override open func editingRect(forBounds bounds: CGRect) -> CGRect
    {
        super.editingRect(forBounds: bounds)
        return self.textRect(forBounds: bounds)

//        let titleHeight = self.titleHeight()
//        let lineHeight = self.selectedLineHeight
//        let rect = CGRect(x: 0, y: titleHeight, width: bounds.size.width, height: bounds.size.height - titleHeight - lineHeight)//.insetBy(dx: inset, dy: inset)
//        return rect
    }
    
    /**
     Calculate the rectangle for the placeholder
     - parameter bounds: The current bounds of the placeholder
     - returns: The rectangle that the placeholder should render in
     */
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        super.editingRect(forBounds: bounds)
        return self.textRect(forBounds: bounds)
        
        //let titleHeight = self.titleHeight()
        //let lineHeight = self.selectedLineHeight
        //let rect = CGRect(x: 0, y: titleHeight, width: bounds.size.width, height: bounds.size.height - titleHeight - lineHeight)//.insetBy(dx: inset, dy: inset)
        //return rect
    }
    
    // MARK: - Positioning Overrides
    
    /**
    Calculate the bounds for the title label. Override to create a custom size title field.
    - parameter bounds: The current bounds of the title
    - parameter editing: True if the control is selected or highlighted
    - returns: The rectangle that the title label should render in
    */
    open func titleLabelRectForBounds(_ bounds:CGRect, editing:Bool) -> CGRect
    {
        if isLine {
            let titleHeight = self.titleHeight()
            let pading = self.rightViewRect(forBounds: bounds).size.width+rightInset + rightInset + self.leftViewRect(forBounds: bounds).size.width + leftInset + leftInset
            if editing {
                return CGRect(x: self.leftViewRect(forBounds: bounds).size.width+leftInset+leftInset, y: 0, width: bounds.size.width-pading, height: titleHeight)
            }
            return CGRect(x: self.leftViewRect(forBounds: bounds).size.width+leftInset+leftInset, y: titleHeight, width: bounds.size.width-pading, height: titleHeight)
        }
        let pading = self.rightViewRect(forBounds: bounds).size.width+rightInset + rightInset + self.leftViewRect(forBounds: bounds).size.width + leftInset + leftInset
        let rect = CGRect(x: self.leftViewRect(forBounds: bounds).size.width + leftInset+leftInset, y: 0, width: bounds.size.width-pading, height: bounds.size.height )//.insetBy(dx: inset, dy: inset)
        return rect
    }

    /**
     Calculate the bounds for the bottom line of the control. Override to create a custom size bottom line in the textbox.
     - parameter bounds: The current bounds of the line
     - parameter editing: True if the control is selected or highlighted
     - returns: The rectangle that the line bar should render in
     */
    open func lineViewRectForBounds(_ bounds:CGRect, editing:Bool) -> CGRect {
        let lineHeight:CGFloat = editing ? CGFloat(self.selectedLineHeight) : CGFloat(self.lineHeight)
        return CGRect(x: 0, y: bounds.size.height - lineHeight, width: bounds.size.width, height: lineHeight);
    }
    
    /**
     Calculate the height of the title label.
     -returns: the calculated height of the title label. Override to size the title with a different height
     */
    open func titleHeight() -> CGFloat {
        if let titleLabel = self.titleLabel,
            let font = titleLabel.font {
                return font.lineHeight
        }
        return 15.0
    }
    
    /**
     Calcualte the height of the textfield.
     -returns: the calculated height of the textfield. Override to size the textfield with a different height
     */
    open func textHeight() -> CGFloat {
        return self.font!.lineHeight + 7.0
    }
    
    // MARK: - Layout
    
    /// Invoked when the interface builder renders the control
    override open func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        self.isSelected = true
        _renderingInInterfaceBuilder = true
        self.updateControl(false)
        self.invalidateIntrinsicContentSize()
    }
    
    /// Invoked by layoutIfNeeded automatically
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        self.titleLabel.frame = self.titleLabelRectForBounds(self.bounds, editing: self.isTitleVisible() || _renderingInInterfaceBuilder)
        self.lineView.frame = self.lineViewRectForBounds(self.bounds, editing: self.editingOrSelected || _renderingInInterfaceBuilder)
    }
    
    /**
     Calculate the content size for auto layout
     
     - returns: the content size to be used for auto layout
     */
    override open var intrinsicContentSize : CGSize {
        return CGSize(width: self.bounds.size.width, height: self.titleHeight() + self.textHeight())
    }
    
    // MARK: - Helpers
    
    fileprivate func titleOrPlaceholder() -> String? {
        if let title = self.title ?? self.placeholder {
            return self.titleFormatter(title)
        }
        return nil
    }
    
    fileprivate func selectedTitleOrTitlePlaceholder() -> String?
    {
        if let title = self.selectedTitle ?? self.title ?? self.placeholder {
            return self.titleFormatter(title)
        }
        return nil
    }
    
    
    
    /////////////////////////////////////////////
    
    /// Text field view mode..///

    
    @IBInspectable var leftInset: CGFloat = 0
    @IBInspectable var rightInset: CGFloat = 0

    @IBInspectable var leftImage: UIImage?{
        didSet{
            leftViewMode = .always
            let leftImage_View = UIImageView(image: leftImage)
            leftImage_View.contentMode = .scaleAspectFit
            leftView = leftImage_View
        }
    }
    
    @IBInspectable var rightImage: UIImage?{
        didSet{
            rightViewMode = .always
            let rightImage_View = UIImageView(image: rightImage)
            rightImage_View.contentMode = .scaleAspectFit
            rightView = rightImage_View
        }
    }

    override open func leftViewRect(forBounds bounds: CGRect) -> CGRect
    {
        super.leftViewRect(forBounds: bounds)
        if isLTRLanguage == false
        {
            return CGRect(x:0, y:0, width:bounds.height, height:bounds.height).insetBy(dx: leftInset, dy: leftInset) //Change frame according to your needs
        }
        if leftImage != nil {
             return CGRect(x:0, y:0, width:bounds.height, height:bounds.height).insetBy(dx: leftInset, dy: leftInset) //Change frame according to your needs
        }
        return CGRect(x:0, y:0, width:0, height:0).insetBy(dx: leftInset, dy: leftInset) //Change frame according to your needs
    }
    
    open override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        super.rightViewRect(forBounds: bounds)
        if isLTRLanguage == false
        {
            return CGRect(x:bounds.width-bounds.height, y:0, width:0, height:bounds.height).insetBy(dx: rightInset, dy: rightInset) //Change frame according to your needs
        }
        if (rightImage != nil) || (rightView != nil) {
            return CGRect(x:bounds.width-bounds.height, y:0, width:bounds.height, height:bounds.height).insetBy(dx: rightInset, dy: rightInset) //Change frame according to your needs
        }
        return CGRect(x:bounds.width-bounds.height, y:0, width:0, height:0).insetBy(dx: rightInset, dy: rightInset) //Change frame according to your needs
    }
    
    
    // Image variable that set the right view mode image
//    @IBInspectable open var rightViewModeImage: UIImage?{
//        didSet
//        {
//            self.createTextFiledViewMode(mode: .Right)
//        }
//    }
    
    // Image variable that set the left view mode image
//    @IBInspectable open var leftViewModeImage: UIImage?{
//        didSet
//        {
//            self.createTextFiledViewMode(mode: .Left)
//        }
//    }
    
//    open override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
//        let leftBounds = CGRect(x: bounds.size.width+22, y: 6, width: 18, height: 18)
//        return leftBounds
//    }
//    override open func rightViewRect(forBounds bounds: CGRect) -> CGRect {
//        let rightBounds = CGRect(x: bounds.size.width-22, y: 6, width: 18, height: 18)
//        return rightBounds
//    }
    
    /// Creates the text field view mode
//    fileprivate func createTextFiledViewMode(mode: TextFieldViewMode)
//    {
//        let view = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
//        let rightButton = UIButton(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
//        rightButton.addTarget(self, action: #selector(SkyFloatingLabelTextField.tapOnRightButton), for: UIControlEvents.touchUpInside)
//        rightButton.center = view.center
//        view.addSubview(rightButton)
//        switch mode
//        {
//        case .Left :
//            rightButton.setBackgroundImage(leftViewModeImage, for: UIControlState())
//            self.leftViewMode = .always;// Set rightview mode
//            self.leftView = view // Set left view
//        case .Right:
//            rightButton.setBackgroundImage(rightViewModeImage, for: UIControlState())
//            self.rightViewMode = .always;// Set rightview mode
//            self.rightView = view // Set right view
//        }
//    }
    
//    func tapOnRightButton()
//    {
//        _ =  self.becomeFirstResponder()
//    }
    /////////////////////////////////////////////////////
    
    
    // Text Field validator.....//
    
    @IBInspectable var validationMsg:String = ""
    //var strLengthValidationMsg = ""
    var supportObj:TextFieldValidatorSupport = TextFieldValidatorSupport()
    var strMsg = ""
    var arrRegx:NSMutableArray = []
    var popUp :IQPopUp?
    
    @IBInspectable var isMandatory:Bool = true   /**< Default is YES*/
    
    @IBOutlet var presentInView:UIView!    /**< Assign view on which you want to show popup and it would be good if you provide controller's view*/
    
    @IBInspectable var popUpColor:UIColor?   /**< Assign popup background color, you can also assign default popup color from macro "ColorPopUpBg" at the top*/
    
    fileprivate var _validateOnCharacterChanged  = false
    @IBInspectable var validateOnCharacterChanged:Bool { /**< Default is YES, Use it whether you want to validate text on character change or not.*/
        
        get {
            return _validateOnCharacterChanged
        }
        set {
            supportObj.validateOnCharacterChanged = newValue
            _validateOnCharacterChanged = newValue
        }
    }
    
    fileprivate var _validateOnResign = false
    @IBInspectable var validateOnResign:Bool {
        get {
            return _validateOnResign
        }
        set {
            supportObj.validateOnResign = newValue
            _validateOnResign = newValue
        }
    }
    
    fileprivate var ColorPopUpBg = UIColor(red: 0.702, green: 0.000, blue: 0.000, alpha: 1.000)
    fileprivate var MsgValidateLength = NSLocalizedString("THIS_FIELD_CANNOT_BE_BLANK", comment: "This field can not be blank")
    
    
    open override var delegate:UITextFieldDelegate?
        {
        didSet {
            supportObj.delegate = delegate
            super.delegate=supportObj
        }
    }
    
    func textFieldValidatorSetup() {
        validateOnCharacterChanged = true
        isMandatory = true
        validateOnResign = true
        popUpColor = ColorPopUpBg
        //strLengthValidationMsg = MsgValidateLength.copy() as! String
        validationMsg = MsgValidateLength.copy() as! String
        supportObj.validateOnCharacterChanged = validateOnCharacterChanged
        supportObj.validateOnResign = validateOnResign
        let notify = NotificationCenter.default
        notify.addObserver(self, selector: #selector(SkyFloatingLabelTextField.didHideKeyboard), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    

    open func addRegx(_ strRegx:String, withMsg msg:String) {
        let dic:NSDictionary = ["regx":strRegx, "msg":msg]
        arrRegx.add(dic)
    }
    
    open func updateLengthValidationMsg(_ msg:String){
//        strLengthValidationMsg = msg
        validationMsg = msg
    }
    
    open func addConfirmValidationTo(_ txtConfirm:SkyFloatingLabelTextField, withMsg msg:String) {
        let dic = ["confirm":txtConfirm, "msg":msg] as [String : Any]
        arrRegx.add(dic)
    }
    
    @objc open func validate() -> Bool
    {
        if isMandatory {
            if self.text?.count == 0 {
                self.showErrorIconForMsg(validationMsg)
                return false
            }
        }
        
        for i in 0 ..< arrRegx.count
        {
            
            let dic = arrRegx.object(at: i)
            
            if (dic as AnyObject).object(forKey: "confirm") != nil {
                let txtConfirm = (dic as AnyObject).object(forKey: "confirm") as! SkyFloatingLabelTextField
                if txtConfirm.text != self.text {
                    self.showErrorIconForMsg((dic as AnyObject).object(forKey: "msg") as! String)
                    return false
                }
            } else if (dic as AnyObject).object(forKey: "regx") as! String != "" &&
                self.text?.count != 0 &&
                !self.validateString(self.text!, withRegex:(dic as AnyObject).object(forKey: "regx") as! String) {
                self.showErrorIconForMsg((dic as AnyObject).object(forKey: "msg") as! String)
                return false
            }
        }
        
        if rightImage != nil {
            self.rightView=nil
            rightViewMode = .always
            let rightImage_View = UIImageView(image: rightImage)
            rightImage_View.contentMode = .scaleAspectFit
            rightView = rightImage_View
        }
        else{
            self.rightView=nil
        }
        return true
    }
    
    open func dismissPopup() {
        popUp?.removeFromSuperview()
    }
    
    // MARK: Internal methods
    
    @objc func didHideKeyboard() {
        popUp?.removeFromSuperview()
    }
    
    @objc func tapOnError() {
        self.showErrorWithMsg(strMsg)
    }
    
    func validateString(_ stringToSearch:String, withRegex regexString:String) ->Bool {
        let regex = NSPredicate(format: "SELF MATCHES %@", regexString)
        return regex.evaluate(with: stringToSearch)
    }
    
    func showErrorIconForMsg(_ msg:String)
    {
        let btnError = UIButton(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        btnError.addTarget(self, action: #selector(SkyFloatingLabelTextField.tapOnError), for: UIControlEvents.touchUpInside)
        btnError.setBackgroundImage(UIImage(named: "error"), for: UIControlState())
        
        let v = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        v.backgroundColor = .red
        if(self.isLTRLanguage)
        {
            self.rightInset = 8;
            self.rightViewMode = .always
            self.rightView = btnError
        }
        else
        {
            self.leftInset = 8;
            self.rightInset = 0;
            self.leftViewMode = .always
            self.leftView = v
            self.rightViewMode = .always
            self.rightView = btnError
        }
        
        strMsg = msg
    }
    
    func showErrorWithMsg(_ msg:String)
    {
        
        if (presentInView == nil)
        {
            presentInView = UIApplication.shared.windows.first
            
            //            [TSMessage showNotificationWithTitle:msg type:TSMessageNotificationTypeError]
            //print("Should set `Present in view` for the UITextField")
            //return
        }
        
        popUp = IQPopUp(frame: CGRect.zero)
        popUp!.strMsg = msg as NSString
        popUp!.popUpColor = popUpColor
        
        if isLTRLanguage == false
        {
            popUp!.showOnRect = self.convert(self.leftView!.frame, to: presentInView)
        }
        else
        {
            popUp!.showOnRect = self.convert(self.rightView!.frame, to: presentInView)
 
        }
        
        popUp!.fieldFrame = self.superview?.convert(self.frame, to: presentInView)
        
        popUp!.backgroundColor = UIColor.clear
        
        presentInView!.addSubview(popUp!)
        
        popUp!.translatesAutoresizingMaskIntoConstraints = false
        let dict = ["v1":popUp!]
        
        popUp?.superview?.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[v1]-0-|", options: NSLayoutFormatOptions(), metrics: nil, views: dict))
        
        popUp?.superview?.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[v1]-0-|", options: NSLayoutFormatOptions(), metrics: nil, views: dict))
        
        supportObj.popUp=popUp
    }

}


///////////////////////////////////

//  -----------------------------------------------


class TextFieldValidatorSupport : NSObject, UITextFieldDelegate
{
    
    var delegate:UITextFieldDelegate?
    var validateOnCharacterChanged: Bool = false
    var validateOnResign = false
    var popUp :IQPopUp?
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    {
        
        if delegate!.responds(to: #selector(TextFieldValidatorSupport.textFieldShouldBeginEditing))
        {
            return delegate!.textFieldShouldBeginEditing!(textField)
        }
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        
        if delegate!.responds(to: #selector(TextFieldValidatorSupport.textFieldDidBeginEditing))
        {
            delegate!.textFieldDidBeginEditing!(textField)
        }
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        if delegate!.responds(to: #selector(TextFieldValidatorSupport.textFieldShouldEndEditing)) {
            return delegate!.textFieldShouldEndEditing!(textField)
        }
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if delegate!.responds(to: #selector(TextFieldValidatorSupport.textFieldDidEndEditing)) {
            delegate?.textFieldDidEndEditing!(textField)
            
        }
        popUp?.removeFromSuperview()
        if validateOnResign
        {
            _ = (textField as! SkyFloatingLabelTextField).validate()
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        (textField as! SkyFloatingLabelTextField).dismissPopup()
        
        if validateOnCharacterChanged {
            
            (textField as! SkyFloatingLabelTextField).perform(#selector(SkyFloatingLabelTextField.validate), with: nil, afterDelay:0.1)
        }
        else
        {
            if (textField as! SkyFloatingLabelTextField).rightImage != nil
            {
                (textField as! SkyFloatingLabelTextField).rightView=nil
                (textField as! SkyFloatingLabelTextField).rightViewMode = .always
                let rightImage_View = UIImageView(image: (textField as! SkyFloatingLabelTextField).rightImage)
                rightImage_View.contentMode = .scaleAspectFit
                (textField as! SkyFloatingLabelTextField).rightView = rightImage_View
            }
            else{
                (textField as! SkyFloatingLabelTextField).rightView=nil
            }
//            if ((textField as! SkyFloatingLabelTextField).rightViewModeImage != nil)
//            {
//                (textField as! SkyFloatingLabelTextField).rightView = nil
//                (textField as! SkyFloatingLabelTextField).createTextFiledViewMode(mode: .Right)
//            }
//            else{
//                (textField as! SkyFloatingLabelTextField).rightView = nil
//            }
        }
        
        if delegate!.responds(to: #selector(UITextFieldDelegate.textField(_:shouldChangeCharactersIn:replacementString:)))
        {
            return delegate!.textField!(textField, shouldChangeCharactersIn: range, replacementString: string)
        }
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        
        if delegate!.responds(to: #selector(TextFieldValidatorSupport.textFieldShouldClear)){
            _ = delegate?.textFieldShouldClear!(textField)
        }
        return true
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if delegate!.responds(to: #selector(TextFieldValidatorSupport.textFieldShouldReturn)) {
            _ = delegate?.textFieldShouldReturn!(textField)
        }
        return true
    }
}

//  -----------------------------------------------

class IQPopUp : UIView {
    
    var showOnRect:CGRect?
    var popWidth:Int = 0
    var fieldFrame:CGRect?
    var strMsg:NSString = ""
    var popUpColor:UIColor?
    var FontSize:CGFloat = 15
    
    var PaddingInErrorPopUp:CGFloat = 5
    var FontName = "Helvetica-Bold"
    
    override func draw(_ rect:CGRect) {
        let color = popUpColor!.cgColor.components
        
        UIGraphicsBeginImageContext(CGSize(width: 30, height: 20))
        let ctx = UIGraphicsGetCurrentContext()
        ctx?.setFillColor(red: (color?[0])!, green: (color?[1])!, blue: (color?[2])!, alpha: 1)
        ctx?.setShadow(offset: CGSize(width: 0, height: 0), blur: 7.0, color: UIColor.black.cgColor)
        let points = [ CGPoint(x: 15, y: 5), CGPoint(x: 25, y: 25), CGPoint(x: 5,y: 25)]
        ctx?.addLines(between: points)
        ctx?.closePath()
        ctx?.fillPath()
        let viewImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        let imgframe = CGRect(x: (showOnRect!.origin.x + ((showOnRect!.size.width-30)/2)),
                                  y: ((showOnRect!.size.height/2) + showOnRect!.origin.y), width: 30, height: 13)
        
        let img = UIImageView(image: viewImage, highlightedImage: nil)
        
        self.addSubview(img)
        img.translatesAutoresizingMaskIntoConstraints = false
        var dict:Dictionary<String, AnyObject> = ["img":img]
        
        
        img.superview?.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: String(format:"H:|-%f-[img(%f)]", imgframe.origin.x, imgframe.size.width), options:NSLayoutFormatOptions(), metrics:nil, views:dict))
        img.superview?.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: String(format:"V:|-%f-[img(%f)]",imgframe.origin.y,imgframe.size.height), options:NSLayoutFormatOptions(),  metrics:nil, views:dict))
        
        let font = UIFont(name: FontName, size: FontSize)
        
        var size:CGSize = self.strMsg.boundingRect(with: CGSize(width: fieldFrame!.size.width - (PaddingInErrorPopUp*2), height: 1000), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font:font!], context: nil).size
        
        
        size = CGSize(width: ceil(size.width), height: ceil(size.height))
        
        
        let view = UIView(frame: CGRect.zero)
        self.insertSubview(view, belowSubview:img)
        view.backgroundColor=self.popUpColor
        view.layer.cornerRadius=5.0
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowRadius=5.0
        view.layer.shadowOpacity=1.0
        view.layer.shadowOffset=CGSize(width: 0, height: 0)
        view.translatesAutoresizingMaskIntoConstraints = false
        dict = ["view":view]
        
        view.superview?.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: String(format:"H:|-%f-[view(%f)]",fieldFrame!.origin.x+(fieldFrame!.size.width-(size.width + (PaddingInErrorPopUp*2))),size.width+(PaddingInErrorPopUp*2)), options:NSLayoutFormatOptions(), metrics:nil, views:dict))
        
        view.superview?.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: String(format:"V:|-%f-[view(%f)]",imgframe.origin.y+imgframe.size.height,size.height+(PaddingInErrorPopUp*2)), options:NSLayoutFormatOptions(),  metrics:nil, views:dict))
        
        let lbl = UILabel(frame: CGRect.zero)
        lbl.font = font
        lbl.numberOfLines=0
        lbl.backgroundColor = UIColor.clear
        lbl.text=self.strMsg as String
        lbl.textColor = UIColor.white
        view.addSubview(lbl)
        
        lbl.translatesAutoresizingMaskIntoConstraints = false
        dict = ["lbl":lbl]
        lbl.superview?.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: String(format:"H:|-%f-[lbl(%f)]", PaddingInErrorPopUp, size.width), options:NSLayoutFormatOptions() , metrics:nil, views:dict))
        lbl.superview?.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: String(format:"V:|-%f-[lbl(%f)]", PaddingInErrorPopUp,size.height), options:NSLayoutFormatOptions(), metrics:nil, views:dict))
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        self.removeFromSuperview()
        return false
    }
}


