﻿//------------------------------------------------------------------------------
// <auto-generated>
//     Этот код создан программой.
//     Исполняемая версия:4.0.30319.42000
//
//     Изменения в этом файле могут привести к неправильной работе и будут потеряны в случае
//     повторной генерации кода.
// </auto-generated>
//------------------------------------------------------------------------------

using System;
using System.ComponentModel;
using System.Diagnostics;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Xml.Serialization;

// 
// Этот исходный код был создан с помощью wsdl, версия=4.6.1055.0.
// 


/// <remarks/>
[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "4.6.1055.0")]
[System.Web.Services.WebServiceBindingAttribute(Name="GetEmployeeLedgerEntries_Binding", Namespace="urn:microsoft-dynamics-schemas/page/getemployeeledgerentries")]
public interface IGetEmployeeLedgerEntries_Binding {
    
    /// <remarks/>
    [System.Web.Services.WebMethodAttribute()]
    [System.Web.Services.Protocols.SoapDocumentMethodAttribute("urn:microsoft-dynamics-schemas/page/getemployeeledgerentries:Read", RequestNamespace="urn:microsoft-dynamics-schemas/page/getemployeeledgerentries", ResponseElementName="Read_Result", ResponseNamespace="urn:microsoft-dynamics-schemas/page/getemployeeledgerentries", Use=System.Web.Services.Description.SoapBindingUse.Literal, ParameterStyle=System.Web.Services.Protocols.SoapParameterStyle.Wrapped)]
    [return: System.Xml.Serialization.XmlElementAttribute("GetEmployeeLedgerEntries")]
    GetEmployeeLedgerEntries Read(int Entry_No);
    
    /// <remarks/>
    [System.Web.Services.WebMethodAttribute()]
    [System.Web.Services.Protocols.SoapDocumentMethodAttribute("urn:microsoft-dynamics-schemas/page/getemployeeledgerentries:ReadByRecId", RequestNamespace="urn:microsoft-dynamics-schemas/page/getemployeeledgerentries", ResponseElementName="ReadByRecId_Result", ResponseNamespace="urn:microsoft-dynamics-schemas/page/getemployeeledgerentries", Use=System.Web.Services.Description.SoapBindingUse.Literal, ParameterStyle=System.Web.Services.Protocols.SoapParameterStyle.Wrapped)]
    [return: System.Xml.Serialization.XmlElementAttribute("GetEmployeeLedgerEntries")]
    GetEmployeeLedgerEntries ReadByRecId(string recId);
    
    /// <remarks/>
    [System.Web.Services.WebMethodAttribute()]
    [System.Web.Services.Protocols.SoapDocumentMethodAttribute("urn:microsoft-dynamics-schemas/page/getemployeeledgerentries:ReadMultiple", RequestNamespace="urn:microsoft-dynamics-schemas/page/getemployeeledgerentries", ResponseElementName="ReadMultiple_Result", ResponseNamespace="urn:microsoft-dynamics-schemas/page/getemployeeledgerentries", Use=System.Web.Services.Description.SoapBindingUse.Literal, ParameterStyle=System.Web.Services.Protocols.SoapParameterStyle.Wrapped)]
    [return: System.Xml.Serialization.XmlArrayAttribute("ReadMultiple_Result")]
    [return: System.Xml.Serialization.XmlArrayItemAttribute(IsNullable=false)]
    GetEmployeeLedgerEntries[] ReadMultiple( GetEmployeeLedgerEntries_Filter[] filter, string bookmarkKey, int setSize);
    
    /// <remarks/>
    [System.Web.Services.WebMethodAttribute()]
    [System.Web.Services.Protocols.SoapDocumentMethodAttribute("urn:microsoft-dynamics-schemas/page/getemployeeledgerentries:IsUpdated", RequestNamespace="urn:microsoft-dynamics-schemas/page/getemployeeledgerentries", ResponseElementName="IsUpdated_Result", ResponseNamespace="urn:microsoft-dynamics-schemas/page/getemployeeledgerentries", Use=System.Web.Services.Description.SoapBindingUse.Literal, ParameterStyle=System.Web.Services.Protocols.SoapParameterStyle.Wrapped)]
    [return: System.Xml.Serialization.XmlElementAttribute("IsUpdated_Result")]
    bool IsUpdated(string Key);
    
    /// <remarks/>
    [System.Web.Services.WebMethodAttribute()]
    [System.Web.Services.Protocols.SoapDocumentMethodAttribute("urn:microsoft-dynamics-schemas/page/getemployeeledgerentries:GetRecIdFromKey", RequestNamespace="urn:microsoft-dynamics-schemas/page/getemployeeledgerentries", ResponseElementName="GetRecIdFromKey_Result", ResponseNamespace="urn:microsoft-dynamics-schemas/page/getemployeeledgerentries", Use=System.Web.Services.Description.SoapBindingUse.Literal, ParameterStyle=System.Web.Services.Protocols.SoapParameterStyle.Wrapped)]
    [return: System.Xml.Serialization.XmlElementAttribute("GetRecIdFromKey_Result")]
    string GetRecIdFromKey(string Key);
}

/// <remarks/>
[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "4.6.1055.0")]
[System.SerializableAttribute()]
[System.Diagnostics.DebuggerStepThroughAttribute()]
[System.ComponentModel.DesignerCategoryAttribute("code")]
[System.Xml.Serialization.XmlTypeAttribute(Namespace="urn:microsoft-dynamics-schemas/page/getemployeeledgerentries")]
public partial class GetEmployeeLedgerEntries {
    
    private string keyField;
    
    private int entry_NoField;
    
    private bool entry_NoFieldSpecified;
    
    private System.DateTime posting_DateField;
    
    private bool posting_DateFieldSpecified;
    
    private string vleDescriptionField;
    
    private string vlePaymPurpField;
    
    private string vendor_NoField;
    
    private int vendor_Ledger_Entry_NoField;
    
    private bool vendor_Ledger_Entry_NoFieldSpecified;
    
    private string vendor_Posting_GroupField;
    
    private Entry_Type entry_TypeField;
    
    private bool entry_TypeFieldSpecified;
    
    private Document_Type document_TypeField;
    
    private bool document_TypeFieldSpecified;
    
    private string document_NoField;
    
    private decimal amount_LCYField;
    
    private bool amount_LCYFieldSpecified;
    
    private int applied_Vend_Ledger_Entry_NoField;
    
    private bool applied_Vend_Ledger_Entry_NoFieldSpecified;
    
    private bool unappliedField;
    
    private bool unappliedFieldSpecified;
    
    private int unapplied_by_Entry_NoField;
    
    private bool unapplied_by_Entry_NoFieldSpecified;
    
    /// <remarks/>
    public string Key {
        get {
            return this.keyField;
        }
        set {
            this.keyField = value;
        }
    }
    
    /// <remarks/>
    public int Entry_No {
        get {
            return this.entry_NoField;
        }
        set {
            this.entry_NoField = value;
        }
    }
    
    /// <remarks/>
    [System.Xml.Serialization.XmlIgnoreAttribute()]
    public bool Entry_NoSpecified {
        get {
            return this.entry_NoFieldSpecified;
        }
        set {
            this.entry_NoFieldSpecified = value;
        }
    }
    
    /// <remarks/>
    [System.Xml.Serialization.XmlElementAttribute(DataType="date")]
    public System.DateTime Posting_Date {
        get {
            return this.posting_DateField;
        }
        set {
            this.posting_DateField = value;
        }
    }
    
    /// <remarks/>
    [System.Xml.Serialization.XmlIgnoreAttribute()]
    public bool Posting_DateSpecified {
        get {
            return this.posting_DateFieldSpecified;
        }
        set {
            this.posting_DateFieldSpecified = value;
        }
    }
    
    /// <remarks/>
    public string vleDescription {
        get {
            return this.vleDescriptionField;
        }
        set {
            this.vleDescriptionField = value;
        }
    }
    
    /// <remarks/>
    public string vlePaymPurp {
        get {
            return this.vlePaymPurpField;
        }
        set {
            this.vlePaymPurpField = value;
        }
    }
    
    /// <remarks/>
    public string Vendor_No {
        get {
            return this.vendor_NoField;
        }
        set {
            this.vendor_NoField = value;
        }
    }
    
    /// <remarks/>
    public int Vendor_Ledger_Entry_No {
        get {
            return this.vendor_Ledger_Entry_NoField;
        }
        set {
            this.vendor_Ledger_Entry_NoField = value;
        }
    }
    
    /// <remarks/>
    [System.Xml.Serialization.XmlIgnoreAttribute()]
    public bool Vendor_Ledger_Entry_NoSpecified {
        get {
            return this.vendor_Ledger_Entry_NoFieldSpecified;
        }
        set {
            this.vendor_Ledger_Entry_NoFieldSpecified = value;
        }
    }
    
    /// <remarks/>
    public string Vendor_Posting_Group {
        get {
            return this.vendor_Posting_GroupField;
        }
        set {
            this.vendor_Posting_GroupField = value;
        }
    }
    
    /// <remarks/>
    public Entry_Type Entry_Type {
        get {
            return this.entry_TypeField;
        }
        set {
            this.entry_TypeField = value;
        }
    }
    
    /// <remarks/>
    [System.Xml.Serialization.XmlIgnoreAttribute()]
    public bool Entry_TypeSpecified {
        get {
            return this.entry_TypeFieldSpecified;
        }
        set {
            this.entry_TypeFieldSpecified = value;
        }
    }
    
    /// <remarks/>
    public Document_Type Document_Type {
        get {
            return this.document_TypeField;
        }
        set {
            this.document_TypeField = value;
        }
    }
    
    /// <remarks/>
    [System.Xml.Serialization.XmlIgnoreAttribute()]
    public bool Document_TypeSpecified {
        get {
            return this.document_TypeFieldSpecified;
        }
        set {
            this.document_TypeFieldSpecified = value;
        }
    }
    
    /// <remarks/>
    public string Document_No {
        get {
            return this.document_NoField;
        }
        set {
            this.document_NoField = value;
        }
    }
    
    /// <remarks/>
    public decimal Amount_LCY {
        get {
            return this.amount_LCYField;
        }
        set {
            this.amount_LCYField = value;
        }
    }
    
    /// <remarks/>
    [System.Xml.Serialization.XmlIgnoreAttribute()]
    public bool Amount_LCYSpecified {
        get {
            return this.amount_LCYFieldSpecified;
        }
        set {
            this.amount_LCYFieldSpecified = value;
        }
    }
    
    /// <remarks/>
    public int Applied_Vend_Ledger_Entry_No {
        get {
            return this.applied_Vend_Ledger_Entry_NoField;
        }
        set {
            this.applied_Vend_Ledger_Entry_NoField = value;
        }
    }
    
    /// <remarks/>
    [System.Xml.Serialization.XmlIgnoreAttribute()]
    public bool Applied_Vend_Ledger_Entry_NoSpecified {
        get {
            return this.applied_Vend_Ledger_Entry_NoFieldSpecified;
        }
        set {
            this.applied_Vend_Ledger_Entry_NoFieldSpecified = value;
        }
    }
    
    /// <remarks/>
    public bool Unapplied {
        get {
            return this.unappliedField;
        }
        set {
            this.unappliedField = value;
        }
    }
    
    /// <remarks/>
    [System.Xml.Serialization.XmlIgnoreAttribute()]
    public bool UnappliedSpecified {
        get {
            return this.unappliedFieldSpecified;
        }
        set {
            this.unappliedFieldSpecified = value;
        }
    }
    
    /// <remarks/>
    public int Unapplied_by_Entry_No {
        get {
            return this.unapplied_by_Entry_NoField;
        }
        set {
            this.unapplied_by_Entry_NoField = value;
        }
    }
    
    /// <remarks/>
    [System.Xml.Serialization.XmlIgnoreAttribute()]
    public bool Unapplied_by_Entry_NoSpecified {
        get {
            return this.unapplied_by_Entry_NoFieldSpecified;
        }
        set {
            this.unapplied_by_Entry_NoFieldSpecified = value;
        }
    }
}

/// <remarks/>
[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "4.6.1055.0")]
[System.SerializableAttribute()]
[System.Xml.Serialization.XmlTypeAttribute(Namespace="urn:microsoft-dynamics-schemas/page/getemployeeledgerentries")]
public enum Entry_Type {
    
    /// <remarks/>
    Initial_Entry,
    
    /// <remarks/>
    Application,
    
    /// <remarks/>
    Unrealized_Loss,
    
    /// <remarks/>
    Unrealized_Gain,
    
    /// <remarks/>
    Realized_Loss,
    
    /// <remarks/>
    Realized_Gain,
    
    /// <remarks/>
    Payment_Discount,
    
    /// <remarks/>
    Payment_Discount_VAT_Excl,
    
    /// <remarks/>
    Payment_Discount_VAT_Adjustment,
    
    /// <remarks/>
    Appln_Rounding,
    
    /// <remarks/>
    Correction_of_Remaining_Amount,
    
    /// <remarks/>
    Payment_Tolerance,
    
    /// <remarks/>
    Payment_Discount_Tolerance,
    
    /// <remarks/>
    Payment_Tolerance_VAT_Excl,
    
    /// <remarks/>
    Payment_Tolerance_VAT_Adjustment,
    
    /// <remarks/>
    Payment_Discount_Tolerance_VAT_Excl,
    
    /// <remarks/>
    Payment_Discount_Tolerance_VAT_Adjustment,
    
    /// <remarks/>
    US_GAAP_Unrealized_Loss,
    
    /// <remarks/>
    US_GAAP_Unrealized_Gain,
    
    /// <remarks/>
    US_GAAP_Realized_Loss,
    
    /// <remarks/>
    US_GAAP_Realized_Gain,
}

/// <remarks/>
[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "4.6.1055.0")]
[System.SerializableAttribute()]
[System.Xml.Serialization.XmlTypeAttribute(Namespace="urn:microsoft-dynamics-schemas/page/getemployeeledgerentries")]
public enum Document_Type {
    
    /// <remarks/>
    _blank_,
    
    /// <remarks/>
    Payment,
    
    /// <remarks/>
    Invoice,
    
    /// <remarks/>
    Credit_Memo,
    
    /// <remarks/>
    Finance_Charge_Memo,
    
    /// <remarks/>
    Reminder,
    
    /// <remarks/>
    Refund,
}

/// <remarks/>
[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "4.6.1055.0")]
[System.SerializableAttribute()]
[System.Diagnostics.DebuggerStepThroughAttribute()]
[System.ComponentModel.DesignerCategoryAttribute("code")]
[System.Xml.Serialization.XmlTypeAttribute(Namespace="urn:microsoft-dynamics-schemas/page/getemployeeledgerentries")]
public partial class GetEmployeeLedgerEntries_Filter {
    
    private GetEmployeeLedgerEntries_Fields fieldField;
    
    private string criteriaField;
    
    /// <remarks/>
    public GetEmployeeLedgerEntries_Fields Field {
        get {
            return this.fieldField;
        }
        set {
            this.fieldField = value;
        }
    }
    
    /// <remarks/>
    public string Criteria {
        get {
            return this.criteriaField;
        }
        set {
            this.criteriaField = value;
        }
    }
}

/// <remarks/>
[System.CodeDom.Compiler.GeneratedCodeAttribute("wsdl", "4.6.1055.0")]
[System.SerializableAttribute()]
[System.Xml.Serialization.XmlTypeAttribute(Namespace="urn:microsoft-dynamics-schemas/page/getemployeeledgerentries")]
public enum GetEmployeeLedgerEntries_Fields {
    
    /// <remarks/>
    Entry_No,
    
    /// <remarks/>
    Posting_Date,
    
    /// <remarks/>
    vleDescription,
    
    /// <remarks/>
    vlePaymPurp,
    
    /// <remarks/>
    Vendor_No,
    
    /// <remarks/>
    Vendor_Ledger_Entry_No,
    
    /// <remarks/>
    Vendor_Posting_Group,
    
    /// <remarks/>
    Entry_Type,
    
    /// <remarks/>
    Document_Type,
    
    /// <remarks/>
    Document_No,
    
    /// <remarks/>
    Amount_LCY,
    
    /// <remarks/>
    Applied_Vend_Ledger_Entry_No,
    
    /// <remarks/>
    Unapplied,
    
    /// <remarks/>
    Unapplied_by_Entry_No,
}
