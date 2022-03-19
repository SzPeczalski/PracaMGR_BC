report 50100 NetValueofDeliveries
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Net Values of Deliveries.rdlc';
    ApplicationArea = All;
    CaptionML = ENU = 'Net Value of Deliveries', PLK = 'Wartości dostaw netto';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Item Ledger Entry"; "Item Ledger Entry")
        {
            column(ReportForNavId_1; 1)
            {
            }
            column(COMPANYNAME; COMPANYNAME)
            {
            }
            column(ReportNameCaption; ReportNameCaptionLbl)
            {
            }
            column(STRSUBSTNO_Text001_StartDateText_; StrSubstNo(Text001, StartDateText))
            {
            }
            column(STRSUBSTNO_Text002_FORMAT_DateEnd__; StrSubstNo(Text002, Format(DateEnd)))
            {
            }
            column(LocationCodeCaption; LocationCodeLbl)
            {
            }
            column(LocationNameCaption; LocationNameLbl)
            {
            }
            column(EntryTypeCaption; EntryTypeLbl)
            {
            }
            column(DocumentTypeCaption; DocumentTypeLbl)
            {
            }
            column(DocumentNoCaption; DocumentNoLbl)
            {
            }
            column(ActualValueCaption; ActualValueCaptionLbl)
            {
            }
            column(ExpectedValueCaption; ExpectedValueCaptionLbl)
            {
            }
            column(BaseLocationCaption; BaseLocationCaptionLbl)
            {
            }
            column(TargetLocationCaption; TargetLocationCaptionLbl)
            {
            }
            column(LocationCode; "Location Code")
            {
            }
            column(EntryType; "Entry Type")
            {
            }
            column(DocumentType; "Document Type")
            {
            }
            column(DocumentNo; "Document No.")
            {
            }
            column(CostAmountActual; "Cost Amount (Actual)")
            {
            }
            column(CostAmountExpected; "Cost Amount (Expected)")
            {
            }
            column(DateFilter; DateFilter)
            {
            }
            column(ShowExpected; ShowExpected)
            {
            }
            column(TransferFromCode; TransferFromCode)
            {
            }
            column(TransferToCode; TransferToCode)
            {
            }
            column(Cost; Cost)
            {
            }
            column(CostExpected; CostExpected)
            {
            }
            dataitem(Location; Location)
            {
                DataItemLink = Code = field("Location Code");
                DataItemLinkReference = "Item Ledger Entry";
                DataItemTableView = sorting(Code) order(ascending);
                column(ReportForNavId_100000010; 100000010)
                {
                }
                column(LocationName; Name)
                {
                }
            }

            trigger OnAfterGetRecord()
            begin
                SetFilter("Posting Date", '%1..%2', DateBegin, DateEnd);

                //Pobrać z Transfer Shipment Header
                TransferFromCode := '';
                TransferToCode := '';
                Cost := 0;
                CostExpected := 0;

                if "Item Ledger Entry"."Document Type" = "Item Ledger Entry"."document type"::"Transfer Shipment" then
                    if TransfShtHdr.Get("Item Ledger Entry"."Document No.") then begin
                        TransferFromCode := TransfShtHdr."Transfer-from Code";
                        TransferToCode := TransfShtHdr."Transfer-to Code";
                    end;
                if "Item Ledger Entry"."Document Type" = "Item Ledger Entry"."document type"::"Transfer Receipt" then
                    if TransfRcpHdr.Get("Item Ledger Entry"."Document No.") then begin
                        TransferFromCode := TransfRcpHdr."Transfer-from Code";
                        TransferToCode := TransfRcpHdr."Transfer-to Code";
                    end;
                if "Item Ledger Entry"."Entry Type" = "Item Ledger Entry"."entry type"::Purchase then begin
                    Cost := "Item Ledger Entry"."Cost Amount (Actual)";
                    CostExpected := "Item Ledger Entry"."Cost Amount (Expected)";
                end;
                if "Item Ledger Entry"."Entry Type" = "Item Ledger Entry"."entry type"::"Negative Adjmt." then begin
                    Cost := "Item Ledger Entry"."Cost Amount (Actual)";
                    CostExpected := "Item Ledger Entry"."Cost Amount (Expected)";
                end;
                if "Item Ledger Entry"."Entry Type" = "Item Ledger Entry"."entry type"::"Positive Adjmt." then begin
                    Cost := "Item Ledger Entry"."Cost Amount (Actual)";
                    CostExpected := "Item Ledger Entry"."Cost Amount (Expected)";
                end;
                if "Item Ledger Entry"."Entry Type" = "Item Ledger Entry"."entry type"::Transfer then begin
                    Cost := "Item Ledger Entry"."Cost Amount (Actual)";
                    CostExpected := "Item Ledger Entry"."Cost Amount (Expected)";
                end;
                if "Item Ledger Entry"."Document Type" = "Item Ledger Entry"."document type"::"Purchase Credit Memo" then begin
                    Cost := "Item Ledger Entry"."Cost Amount (Actual)";
                    CostExpected := "Item Ledger Entry"."Cost Amount (Expected)";
                end;
                if "Item Ledger Entry"."Document Type" = "Item Ledger Entry"."document type"::"Sales Credit Memo" then begin
                    Cost := "Item Ledger Entry"."Cost Amount (Actual)";
                    CostExpected := "Item Ledger Entry"."Cost Amount (Expected)";
                end;
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    field(DateBegin; DateBegin)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Date Begin';
                    }
                    field(DateEnd; DateEnd)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Date End';
                    }
                    field(IncludeExpectedCost; ShowExpected)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Include Expected Cost';
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
        Location_Code_NameCaption = 'Location Code Group Name';
    }

    trigger OnPreReport()
    begin
        if (DateBegin = 0D) and (DateEnd = 0D) then
            DateEnd := WorkDate;

        if DateBegin in [0D, 00000101D] then
            StartDateText := ''
        else
            StartDateText := Format(DateBegin);
    end;

    var
        ReportNameCaptionLbl: label 'Net Delivery Values';
        LocationCodeLbl: label 'Location Code Caption';
        LocationNameLbl: label 'Location Name Caption';
        EntryTypeLbl: label 'Entry Type';
        DocumentTypeLbl: label 'Document Type';
        DocumentNoLbl: label 'Document No.';
        DocumentNo: Integer;
        ShowExpected: Boolean;
        ActualValueCaptionLbl: label 'Actual Value Caption';
        ExpectedValueCaptionLbl: label 'Expected Value Caption';
        BaseLocationCaptionLbl: label 'Base Location Caption';
        TargetLocationCaptionLbl: label 'Target Location Caption';
        DateBegin: Date;
        DateEnd: Date;
        DateFilter: Text;
        Text001: label 'From %1';
        StartDateText: Text;
        Text002: label 'To %1';
        ShowLocationCode: Integer;
        TransferFromCode: Code[20];
        TransferToCode: Code[20];
        TransfShtHdr: Record "Transfer Shipment Header";
        TransfRcpHdr: Record "Transfer Receipt Header";
        Cost: Decimal;
        CostExpected: Decimal;

    local procedure SetStartDate()
    begin
    end;

    local procedure SetEndDate()
    begin
    end;

    local procedure SumOfCosts()
    begin
    end;
}