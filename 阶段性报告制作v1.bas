Attribute VB_Name = "�׶��Ա�������v1"
'Date: 2016.8.1-2016.9.18
'Author: Vinson Wei
'Purpose: Automate the process of making a periodic report

Dim factoryinphase$, year$, startMonth$, endMonth$, currentUseWB As Workbook

Dim status As Integer

Dim HRC00, HRC01, HRC02, HRC03, HRC04, HRC05, HRC06, HRC07, HRC08, HRC09, HRC10, HRC11, HRC12, _
HRC13, HRC14, HRC14Dot5, HRC14Dot6, HRC15, HRC16, HRC17, HRC18, HRC19, HRC20, HRC21, HRC22, _
HRC23, HRC24, HRC25, HRC26, HRC27, HRC28, HRC29, HRC30, HRC31, HRC32, HRC33 As Integer


Sub mainInitializationInPhaseReport(ByRef status As Integer)
factoryinphase = InputBox(prompt:="�����빤�����룺")

If factoryinphase = "" Then
status = 1
Exit Sub
End If

year = InputBox(prompt:="�����뱾�ļ������±�������ݣ���2015")

If year = "" Then
status = 2
Exit Sub
End If

startMonth = InputBox(prompt:="�����뱾��ȡ����ļ������±�����ʼ�£���3����ʾ3�£�")

If startMonth = "" Then
status = 3
Exit Sub
End If

endMonth = InputBox(prompt:="�����뱾��ȡ����ļ������±������һ���£���12����ʾ12�£�")

If endMonth = "" Then
status = 4
Exit Sub
End If

Set currentUseWB = ActiveWorkbook
On Error Resume Next
currentUseWB.Worksheets("Sheet2").Delete
currentUseWB.Worksheets("Sheet3").Delete
End Sub

Sub mainOpenCopyCloseOneiMonthlyReport(control As IRibbonControl)
'control As IRibbonControl
status = 0
Call mainInitializationInPhaseReport(status)

If status <> 0 Then
    Select Case status
        Case 1
            MsgBox "δ���빤�����룬���ȷ���˳��±����ݵ���"
        Case 2
            MsgBox "δ������ȣ����ȷ���˳��±����ݵ���"
        Case 3
            MsgBox "δ���뱾����±���ʼ�·ݣ����ȷ���˳��±����ݵ���"
        Case 4
            MsgBox "δ���뱾����±����һ���·ݣ����ȷ���˳��±����ݵ���"
    End Select
Exit Sub
End If

Dim f$, WB As Workbook, pw$, loc$, sht As Worksheet, nameList

'д�û��ܱ��ͷ
If currentUseWB.Worksheets("Sheet1").Range("H1").Value = "" Then

    currentUseWB.Worksheets("Sheet1").Range("A1").Value = "����"
    currentUseWB.Worksheets("Sheet1").Range("B1").Value = "�������"
    currentUseWB.Worksheets("Sheet1").Range("C1").Value = "��ɫ"
    currentUseWB.Worksheets("Sheet1").Range("D1").Value = "�¼�����"
    currentUseWB.Worksheets("Sheet1").Range("E1").Value = "�������"
    currentUseWB.Worksheets("Sheet1").Range("F1").Value = "��ͨ��ʽ"
    currentUseWB.Worksheets("Sheet1").Range("G1").Value = "�����Ա�"
    currentUseWB.Worksheets("Sheet1").Range("H1").Value = "��������"
    currentUseWB.Worksheets("Sheet1").Range("I1").Value = "��������"
    rStart = 2
    lStart = 2
Else
    Set lastCell = currentUseWB.Worksheets("Sheet1").Range("H1").End(xlDown)
    rStart = lastCell.Row + 1
    lStart = rStart
End If

iRInSheet1 = rStart
iLInSheet1 = lStart
For iMonth = Val(startMonth) To Val(endMonth)

'��ѯ�±��ļ������±��ļ�
f = Dir(currentUseWB.Path & "\*" & factoryinphase & "*" & iMonth & "��*" & "��������.xls*")
loc = InStr(f, " ")
If loc = 0 Then loc = InStr(f, " ")
pw = Trim(Mid(f, 1, loc - 1))
Set WB = Workbooks.Open(Filename:=currentUseWB.Path & "\" & f, Password:=pw)


'������������������뵽nameList���������
Set nameList = CreateObject("System.Collections.ArrayList")
For Each sht In WB.Worksheets
    If sht.Name Like ("*" & factoryinphase & "*") Then
        nameList.Add sht.Name
    End If
Next

'�ȴ��±���ÿ�Ÿ����������н������������˹���

For i = 0 To nameList.Count - 1
    WB.Worksheets(nameList(i)).Range("B5").Copy currentUseWB.Worksheets("Sheet1").Range("H" & iRInSheet1)
    With currentUseWB.Worksheets("Sheet1").Range("H" & iRInSheet1).Borders(xlEdgeBottom)
        .LineStyle = xlContinuous
        .ColorIndex = 0
        .TintAndShade = 0
        .Weight = xlMedium
    End With
    iRInSheet1 = iRInSheet1 + 1
Next

'�ٴ�Quesiton Sheet���н�������š���ɫ���¼����͡��������һ�ζ����˹���
WB.Worksheets("Question Sheet").Range("A2", "D" & (nameList.Count + 1)).Copy _
currentUseWB.Worksheets("Sheet1").Range("B" & iLInSheet1)


'��Case Sheet���н���ͨ��ʽ�������Ա���˹���
WB.Worksheets("Case Sheet").Range("F2", "G" & (nameList.Count + 1)).Copy _
currentUseWB.Worksheets("Sheet1").Range("F" & iLInSheet1)

'д������
For i = iLInSheet1 To (iRInSheet1 - 1)
currentUseWB.Worksheets("Sheet1").Range("A" & i).Value = "'" & year & "��" & iMonth & "��"
iLInSheet1 = iLInSheet1 + 1
Next

endCode = currentUseWB.Worksheets("Sheet1").Range("B" & (iLInSheet1 - 1)).Value

If Trim(endCode) <> nameList(nameList.Count - 1) Then
    MsgBox "ע�⣬���ڷ�����һ��������������Ҳ�" & year & "��" & iMonth & "�µ��±���" _
    & "��ĳ����������������������������������һ��������ţ�����" & "�����˵���ʱ������λ�����ȷ�������򽫳����Զ������λ��"
    GoTo iLNotEqualToiR
End If

'�����������￪ʼ
iLEqualToiR:
iLInSheet1 = iRInSheet1

WB.Close False

Next

With currentUseWB.Worksheets("Sheet1").Range("A1", "G" & (iLInSheet1 - 1))
        .RowHeight = 25
        .HorizontalAlignment = xlGeneral
        .VerticalAlignment = xlCenter
        .Borders(xlDiagonalDown).LineStyle = xlNone
        .Borders(xlDiagonalUp).LineStyle = xlNone
        .Borders(xlEdgeLeft).LineStyle = xlNone
        .Borders(xlEdgeTop).LineStyle = xlNone
        .Borders(xlEdgeBottom).LineStyle = xlNone
        .Borders(xlEdgeRight).LineStyle = xlNone
        .Borders(xlInsideVertical).LineStyle = xlNone
        .Borders(xlInsideHorizontal).LineStyle = xlNone
        .WrapText = True
        .Orientation = 0
        .AddIndent = False
        .IndentLevel = 0
        .ShrinkToFit = False
        .ReadingOrder = xlContext
        .MergeCells = False
End With

currentUseWB.Worksheets("Sheet1").Columns("A:I").AutoFit
currentUseWB.Worksheets("Sheet1").Columns("H").ColumnWidth = 45
'MsgBox "iLInSheet1:" & iLInSheet1 & "iRInSheet1:" & iRInSheet1
MsgBox year & "����±�������ϣ�����ȷ�������������һ��ȵ��±���Ҫ���룬���ȸ��Ʊ�Excel�ļ����ⲿ���±������ļ��У��ظ����벽��"

Exit Sub
iLNotEqualToiR:
currentUseWB.Worksheets("Sheet1").Activate
stRow = iRInSheet1 - nameList.Count
Set range00 = currentUseWB.Worksheets("Sheet1").Cells(stRow, 1)
range00.Resize(nameList.Count + 2, 8).Clear


iRInSheet1 = iRInSheet1 - nameList.Count

startRowInThis = iRInSheet1

storeSheet = ""
For i = 0 To nameList.Count - 1
       WB.Worksheets(nameList(i)).Range("B5").Copy currentUseWB.Worksheets("Sheet1").Range("H" & iRInSheet1)
   If Len(Trim(WB.Worksheets(nameList(i)).Range("A6").Value)) <> 0 Then
        storeSheet = nameList(i)
       WB.Worksheets(nameList(i)).Range("B6").Copy currentUseWB.Worksheets("Sheet1").Range("H" & (iRInSheet1 + 1))
   End If
    With currentUseWB.Worksheets("Sheet1").Range("H" & iRInSheet1).Borders(xlEdgeBottom)
        .LineStyle = xlContinuous
        .ColorIndex = 0
        .TintAndShade = 0
        .Weight = xlMedium
    End With
    If Len(Trim(WB.Worksheets(nameList(i)).Range("A6").Value)) <> 0 Then
        iRInSheet1 = iRInSheet1 + 2
    Else
         iRInSheet1 = iRInSheet1 + 1
    End If
Next

'�ٴ�Quesiton Sheet���н�������š���ɫ���¼����͡��������һ�ζ����˹���
endRowInThis = WB.Worksheets("Question Sheet").Range("A2").End(xlDown).Row
WB.Worksheets("Question Sheet").Range("A2").Resize(endRowInThis - 1, 4).Copy _
currentUseWB.Worksheets("Sheet1").Range("B" & startRowInThis)

'======================2016��9��7��00:11:28����������=====================
'̸��storeSheet�������¶��¼��Ĺ���������Ȼ���������ѭ�����빵ͨ��ʽ�������Ա�

'��Case Sheet���н���ͨ��ʽ�������Ա���˹���
startRowInThis0 = startRowInThis
For i = 2 To nameList.Count + 1
    pTroubleCase = factoryinphase & "-" & WB.Worksheets("Case Sheet").Cells(i, 4).Value
    If storeSheet = pTroubleCase Then
     WB.Worksheets("Case Sheet").Cells(i, 6).Resize(1, 2).Copy currentUseWB.Worksheets("Sheet1").Cells(startRowInThis0, 6).Resize(1, 2)
     WB.Worksheets("Case Sheet").Cells(i, 6).Resize(1, 2).Copy currentUseWB.Worksheets("Sheet1").Cells(startRowInThis0 + 1, 6).Resize(1, 2)
     startRowInThis0 = startRowInThis0 + 2
     Else
        WB.Worksheets("Case Sheet").Cells(i, 6).Resize(1, 2).Copy currentUseWB.Worksheets("Sheet1").Cells(startRowInThis0, 6).Resize(1, 2)
        startRowInThis0 = startRowInThis0 + 1
    End If
Next


'д�����£����޸�
For i = startRowInThis To (iRInSheet1 - 1)
currentUseWB.Worksheets("Sheet1").Range("A" & i).Value = "'" & year & "��" & iMonth & "��"
iLInSheet1 = iLInSheet1 + 1
Next
MsgBox "Ok����λ�����ѽ������������������С�"
GoTo iLEqualToiR


End Sub
Sub mainCreatePivotTable(control As IRibbonControl)
On Error Resume Next
    Application.DisplayAlerts = False
    currentUseWB.Sheets("PivotSheet").Delete
    Application.DisplayAlerts = False
On Error GoTo 0


Dim pivotSheet As Worksheet, rg As Range, endCell As Range
Set currentUseWB = ActiveWorkbook
'��������Դ
Set pivotSheet = currentUseWB.Worksheets.Add(after:=currentUseWB.Worksheets("Sheet1"))
pivotSheet.Name = "PivotSheet"
Set endCell = currentUseWB.Worksheets("Sheet1").Range("E2").End(xlDown)
currentUseWB.Worksheets("Sheet1").Activate
endCell.Select
Set rg = Range(Range("D1"), endCell)

 currentUseWB.PivotCaches.Create(SourceType:=xlDatabase, SourceData:= _
        rg, Version:=xlPivotTableVersion10).CreatePivotTable _
        TableDestination:="PivotSheet!R3C1", TableName:="PivotTable", DefaultVersion:= _
        xlPivotTableVersion10
    Worksheets("PivotSheet").Select
    currentUseWB.ShowPivotTableFieldList = True
    With currentUseWB.Worksheets("PivotSheet").PivotTables("PivotTable").PivotFields("�¼�����")
        .Orientation = xlRowField
        .Position = 1
    End With
        currentUseWB.Worksheets("PivotSheet").PivotTables("PivotTable").AddDataField currentUseWB.Worksheets("PivotSheet").PivotTables("PivotTable" _
        ).PivotFields("�������"), "������������", xlCount
    With currentUseWB.Worksheets("PivotSheet").PivotTables("PivotTable").PivotFields("�������")
        .Orientation = xlColumnField
        .Position = 1
    End With

    currentUseWB.ShowPivotTableFieldList = False
    
    MsgBox "����͸�ӱ��������"
End Sub

Sub mainCreatePieChart(control As IRibbonControl)
Set currentUseWB = ActiveWorkbook
' ��������Դ


On Error Resume Next
    Application.DisplayAlerts = False
    currentUseWB.Sheets("PieChart").Delete
    currentUseWB.Sheets("Gender").Delete
    currentUseWB.Sheets("InMethod").Delete
    currentUseWB.Sheets("SourceData").Delete
    Application.DisplayAlerts = False
On Error GoTo 0
' ��ͼ����
Dim srcSheeet As Worksheet
Dim d, d1, d2 As Object, arr, i&
Set d = CreateObject("scripting.dictionary")
currentUseWB.Worksheets("Sheet1").Activate
arr = currentUseWB.Worksheets("Sheet1").Range([E2], [E65536].End(xlUp))
For i = 1 To UBound(arr)
    If arr(i, 1) <> "" Then d(arr(i, 1)) = ""
Next

Set srcSheet = currentUseWB.Worksheets.Add(after:=currentUseWB.Worksheets(currentUseWB.Worksheets.Count))
srcSheet.Name = "SourceData"

currentUseWB.Worksheets("SourceData").[A2].Resize(d.Count) = Application.Transpose(d.keys)

currentUseWB.Worksheets("SourceData").[B1].Value = "��������"

currentUseWB.Worksheets("Sheet1").Activate
Set arr = currentUseWB.Worksheets("Sheet1").Range([E2], [E65536].End(xlUp))

For i = 2 To d.Count + 1
currentUseWB.Worksheets("SourceData").Range("B" & i) = _
WorksheetFunction.CountIf(arr, currentUseWB.Worksheets("SourceData").Range("A" & i))
Next

currentUseWB.Worksheets("SourceData").Sort.SortFields.Clear
   currentUseWB.Worksheets("SourceData").Sort.SortFields.Add Key:=Range("B2") _
        , SortOn:=xlSortOnValues, Order:=xlDescending, DataOption:=xlSortNormal
    With currentUseWB.Worksheets("SourceData").Sort
        .SetRange Range("A2:B" & (d.Count + 1))
        .Header = xlNo
        .MatchCase = False
        .Orientation = xlTopToBottom
        .SortMethod = xlPinYin
        .Apply
    End With


' �Ա������״ͼ
genderStartRow = d.Count + 3

Set d1 = CreateObject("scripting.dictionary")
arr = currentUseWB.Worksheets("Sheet1").Range([G2], [G65536].End(xlUp))
For i = 1 To UBound(arr)
    If arr(i, 1) <> "" Then d1(arr(i, 1)) = ""
Next

currentUseWB.Worksheets("SourceData").Range("B" & genderStartRow) = "�Ա�"
currentUseWB.Worksheets("SourceData").Range("A" & (genderStartRow + 1)).Resize(d1.Count) = Application.Transpose(d1.keys)

currentUseWB.Worksheets("Sheet1").Activate
Set arr = currentUseWB.Worksheets("Sheet1").Range([G2], [G65536].End(xlUp))

For i = genderStartRow + 1 To genderStartRow + d1.Count
currentUseWB.Worksheets("SourceData").Range("B" & i) = _
WorksheetFunction.CountIf(arr, currentUseWB.Worksheets("SourceData").Range("A" & i))
Next

'���뷽ʽ����
inMethodStartRow = genderStartRow + d1.Count + 2

Set d2 = CreateObject("scripting.dictionary")
arr = currentUseWB.Worksheets("Sheet1").Range([F2], [F65536].End(xlUp))
For i = 1 To UBound(arr)
    If arr(i, 1) <> "" Then d2(arr(i, 1)) = ""
Next

currentUseWB.Worksheets("SourceData").Range("B" & inMethodStartRow) = "���뷽ʽ"
currentUseWB.Worksheets("SourceData").Range("A" & (inMethodStartRow + 1)).Resize(d2.Count) = Application.Transpose(d2.keys)

currentUseWB.Worksheets("Sheet1").Activate
Set arr = currentUseWB.Worksheets("Sheet1").Range([F2], [F65536].End(xlUp))

For i = inMethodStartRow + 1 To inMethodStartRow + d2.Count
currentUseWB.Worksheets("SourceData").Range("B" & i) = _
WorksheetFunction.CountIf(arr, currentUseWB.Worksheets("SourceData").Range("A" & i))
Next



'��������Ҫ��ı�ͼ
If d.Count > 4 Then
    If currentUseWB.Worksheets("SourceData").[B5] = currentUseWB.Worksheets("SourceData").[B6] Then
        If currentUseWB.Worksheets("SourceData").[B6] = currentUseWB.Worksheets("SourceData").[B7] Then
            If currentUseWB.Worksheets("SourceData").[B7] = currentUseWB.Worksheets("SourceData").[B8] Then
                If currentUseWB.Worksheets("SourceData").[B8] = currentUseWB.Worksheets("SourceData").[B9] Then
                    endRow = 9
                Else
                    endRow = 8
                End If
            Else
                endRow = 7
            End If
        Else
            endRow = 6
        End If
    Else
        endRow = 5
    End If
Else
    endRow = d.Count + 1
End If

currentUseWB.Worksheets("SourceData").Range("s2").Value = endRow
currentUseWB.Worksheets("SourceData").Range("s1").Value = "��ͼ�����һ�����������������(endRow)"

sumOfPie = WorksheetFunction.Sum(currentUseWB.Worksheets("SourceData").Range("B2", "B" & endRow))

For i = 2 To endRow
    currentUseWB.Worksheets("SourceData").Range("B" & i) = _
    currentUseWB.Worksheets("SourceData").Range("B" & i) / sumOfPie
Next
currentUseWB.Worksheets("SourceData").Range("B2", "B" & endRow).NumberFormatLocal = "0.00%"


'===========================================
'�˴�ͳ��Word�ĵ����Ĳ�����������
'����λ����SourceData��������

'д�ñ����
realEndRow = currentUseWB.Worksheets("SourceData").[A2].End(xlDown).Row
For i = 2 To realEndRow

    For j = 3 To 17 Step 2
        If j = 3 Then currentUseWB.Worksheets("SourceData").Cells(i, j).Value = "��ѯ"
        If j = 5 Then currentUseWB.Worksheets("SourceData").Cells(i, j).Value = "ռ��ѯ�ٷֱ�"
        If j = 7 Then currentUseWB.Worksheets("SourceData").Cells(i, j).Value = "����"
        If j = 9 Then currentUseWB.Worksheets("SourceData").Cells(i, j).Value = "ռ����ٷֱ�"
        If j = 11 Then currentUseWB.Worksheets("SourceData").Cells(i, j).Value = "Ͷ��"
        If j = 13 Then currentUseWB.Worksheets("SourceData").Cells(i, j).Value = "ռͶ�߰ٷֱ�"
        If j = 15 Then currentUseWB.Worksheets("SourceData").Cells(i, j).Value = currentUseWB.Worksheets("SourceData").Cells(i, 1).Value
        If j = 17 Then currentUseWB.Worksheets("SourceData").Cells(i, j).Value = "ռ�ܸ����ٷֱ�"
    Next

Next



'ͳ�Ƶ�endRowΪֹ��������������¼�����

For i = 2 To realEndRow

    For j = 4 To 16 Step 4
        currentUseWB.Worksheets("SourceData").Cells(i, j).Value = _
        Application.WorksheetFunction.CountIfs(currentUseWB.Worksheets("Sheet1").Range("D:D"), currentUseWB.Worksheets("SourceData").Cells(i, j - 1).Value, _
        currentUseWB.Worksheets("Sheet1").Range("E:E"), currentUseWB.Worksheets("SourceData").Cells(i, 1).Value)
    Next
    

Next

'=========================
ctGreen = 0
ctYellow = 0
ctRed = 0
ctZixun = 0
ctXinli = 0
ctTousu = 0

With currentUseWB.Worksheets("Sheet1")

For i = 2 To .[A65536].End(xlUp).Row
    If Trim(.Range("C" & i).Value) = "��" Then ctGreen = ctGreen + 1
    If Trim(.Range("C" & i).Value) = "��" Then ctYellow = ctYellow + 1
    If Trim(.Range("C" & i).Value) = "��" Then ctRed = ctRed + 1
    If Trim(.Range("D" & i).Value) = "��ѯ" Then ctZixun = ctZixun + 1
    If Trim(.Range("D" & i).Value) = "Ͷ��" Then ctTousu = ctTousu + 1
    If Trim(.Range("D" & i).Value) = "����" Then ctXinli = ctXinli + 1
Next

End With

'=========================


For i = 2 To realEndRow

    For j = 6 To 14 Step 4
    
    If j = 6 Then currentUseWB.Worksheets("SourceData").Cells(i, j).Value = Format(currentUseWB.Worksheets("SourceData").Cells(i, j - 2).Value / ctZixun, "0.00%")
    If j = 10 Then currentUseWB.Worksheets("SourceData").Cells(i, j).Value = Format(currentUseWB.Worksheets("SourceData").Cells(i, j - 2).Value / ctXinli, "0.00%")
    If j = 14 Then currentUseWB.Worksheets("SourceData").Cells(i, j).Value = Format(currentUseWB.Worksheets("SourceData").Cells(i, j - 2).Value / ctTousu, "0.00%")
    Next
Next

Set hiDict = CreateObject("scripting.dictionary")
hiDict.Add "��ѯ", ctZixun
hiDict.Add "����", ctXinli
hiDict.Add "Ͷ��", ctTousu

numOfAllCases = currentUseWB.Worksheets("Sheet1").[A65536].End(xlUp).Row - 1
For i = 2 To realEndRow

        currentUseWB.Worksheets("SourceData").Cells(i, 16).Value = _
        Application.WorksheetFunction.CountIfs(currentUseWB.Worksheets("Sheet1").Range("E:E"), currentUseWB.Worksheets("SourceData").Cells(i, 15).Value)
    currentUseWB.Worksheets("SourceData").Cells(i, 18).Value = Format(currentUseWB.Worksheets("SourceData").Cells(i, 16).Value / numOfAllCases, "0.00%")
    
Next



'===========================================

Set pieChart = currentUseWB.Charts.Add(after:=currentUseWB.Worksheets("SourceData"))
pieChart.Name = "PieChart"
pieChart.ChartType = xl3DPieExploded
pieChart.SetSourceData Source:=currentUseWB.Sheets("SourceData").Range("A1:B" & endRow)
pieChart.SeriesCollection(1).Select
pieChart.SeriesCollection(1).ApplyDataLabels
pieChart.PlotArea.Select
pieChart.ChartArea.Select

Set barChart = currentUseWB.Charts.Add(after:=currentUseWB.Worksheets("SourceData"))
barChart.Name = "Gender"
barChart.ChartType = xlColumnClustered
barChart.SetSourceData Source:=currentUseWB.Sheets("SourceData").Range("A" & genderStartRow & ":B" & (genderStartRow + d1.Count))
barChart.SeriesCollection(1).ApplyDataLabels

Set barChart1 = currentUseWB.Charts.Add(after:=currentUseWB.Worksheets("SourceData"))
barChart1.Name = "InMethod"
barChart1.ChartType = xlColumnClustered
barChart1.SetSourceData Source:=currentUseWB.Sheets("SourceData").Range("A" & inMethodStartRow & ":B" & (inMethodStartRow + d2.Count))
barChart1.SeriesCollection(1).ApplyDataLabels

currentUseWB.Worksheets("Sheet1").Activate
currentUseWB.Worksheets("Sheet1").[A1].Select

MsgBox "�ɹ�������һ����ͼ��������״ͼ����ע�����������״ͼ������ֻ��һ�У�����ֻ���л���ֻ��QQ���룩������״ͼ�ĸ�ʽ���������⣬��Ҫ�ֹ��޸ĸ�ʽ"

End Sub
Sub mainCreatePieChart1()
Set currentUseWB = ActiveWorkbook
' ��������Դ


On Error Resume Next
    Application.DisplayAlerts = False
    currentUseWB.Sheets("PieChart").Delete
    currentUseWB.Sheets("Gender").Delete
    currentUseWB.Sheets("InMethod").Delete
    currentUseWB.Sheets("SourceData").Delete
    Application.DisplayAlerts = False
On Error GoTo 0
' ��ͼ����
Dim srcSheeet As Worksheet
Dim d, d1, d2 As Object, arr, i&
Set d = CreateObject("scripting.dictionary")
currentUseWB.Worksheets("Sheet1").Activate
arr = currentUseWB.Worksheets("Sheet1").Range([E2], [E65536].End(xlUp))
For i = 1 To UBound(arr)
    If arr(i, 1) <> "" Then d(arr(i, 1)) = ""
Next

Set srcSheet = currentUseWB.Worksheets.Add(after:=currentUseWB.Worksheets(currentUseWB.Worksheets.Count))
srcSheet.Name = "SourceData"

currentUseWB.Worksheets("SourceData").[A2].Resize(d.Count) = Application.Transpose(d.keys)

currentUseWB.Worksheets("SourceData").[B1].Value = "��������"

currentUseWB.Worksheets("Sheet1").Activate
Set arr = currentUseWB.Worksheets("Sheet1").Range([E2], [E65536].End(xlUp))

For i = 2 To d.Count + 1
currentUseWB.Worksheets("SourceData").Range("B" & i) = _
WorksheetFunction.CountIf(arr, currentUseWB.Worksheets("SourceData").Range("A" & i))
Next

currentUseWB.Worksheets("SourceData").Sort.SortFields.Clear
   currentUseWB.Worksheets("SourceData").Sort.SortFields.Add Key:=Range("B2") _
        , SortOn:=xlSortOnValues, Order:=xlDescending, DataOption:=xlSortNormal
    With currentUseWB.Worksheets("SourceData").Sort
        .SetRange Range("A2:B" & (d.Count + 1))
        .Header = xlNo
        .MatchCase = False
        .Orientation = xlTopToBottom
        .SortMethod = xlPinYin
        .Apply
    End With


' �Ա������״ͼ
genderStartRow = d.Count + 3

Set d1 = CreateObject("scripting.dictionary")
arr = currentUseWB.Worksheets("Sheet1").Range([G2], [G65536].End(xlUp))
For i = 1 To UBound(arr)
    If arr(i, 1) <> "" Then d1(arr(i, 1)) = ""
Next

currentUseWB.Worksheets("SourceData").Range("B" & genderStartRow) = "�Ա�"
currentUseWB.Worksheets("SourceData").Range("A" & (genderStartRow + 1)).Resize(d1.Count) = Application.Transpose(d1.keys)

currentUseWB.Worksheets("Sheet1").Activate
Set arr = currentUseWB.Worksheets("Sheet1").Range([G2], [G65536].End(xlUp))

For i = genderStartRow + 1 To genderStartRow + d1.Count
currentUseWB.Worksheets("SourceData").Range("B" & i) = _
WorksheetFunction.CountIf(arr, currentUseWB.Worksheets("SourceData").Range("A" & i))
Next

'���뷽ʽ����
inMethodStartRow = genderStartRow + d1.Count + 2

Set d2 = CreateObject("scripting.dictionary")
arr = currentUseWB.Worksheets("Sheet1").Range([F2], [F65536].End(xlUp))
For i = 1 To UBound(arr)
    If arr(i, 1) <> "" Then d2(arr(i, 1)) = ""
Next

currentUseWB.Worksheets("SourceData").Range("B" & inMethodStartRow) = "���뷽ʽ"
currentUseWB.Worksheets("SourceData").Range("A" & (inMethodStartRow + 1)).Resize(d2.Count) = Application.Transpose(d2.keys)

currentUseWB.Worksheets("Sheet1").Activate
Set arr = currentUseWB.Worksheets("Sheet1").Range([F2], [F65536].End(xlUp))

For i = inMethodStartRow + 1 To inMethodStartRow + d2.Count
currentUseWB.Worksheets("SourceData").Range("B" & i) = _
WorksheetFunction.CountIf(arr, currentUseWB.Worksheets("SourceData").Range("A" & i))
Next



'��������Ҫ��ı�ͼ
If d.Count > 4 Then
    If currentUseWB.Worksheets("SourceData").[B5] = currentUseWB.Worksheets("SourceData").[B6] Then
        If currentUseWB.Worksheets("SourceData").[B6] = currentUseWB.Worksheets("SourceData").[B7] Then
            If currentUseWB.Worksheets("SourceData").[B7] = currentUseWB.Worksheets("SourceData").[B8] Then
                If currentUseWB.Worksheets("SourceData").[B8] = currentUseWB.Worksheets("SourceData").[B9] Then
                    endRow = 9
                Else
                    endRow = 8
                End If
            Else
                endRow = 7
            End If
        Else
            endRow = 6
        End If
    Else
        endRow = 5
    End If
Else
    endRow = d.Count + 1
End If

currentUseWB.Worksheets("SourceData").Range("s2").Value = endRow
currentUseWB.Worksheets("SourceData").Range("s1").Value = "��ͼ�����һ�����������������(endRow)"

sumOfPie = WorksheetFunction.Sum(currentUseWB.Worksheets("SourceData").Range("B2", "B" & endRow))

For i = 2 To endRow
    currentUseWB.Worksheets("SourceData").Range("B" & i) = _
    currentUseWB.Worksheets("SourceData").Range("B" & i) / sumOfPie
Next
currentUseWB.Worksheets("SourceData").Range("B2", "B" & endRow).NumberFormatLocal = "0.00%"


'===========================================
'�˴�ͳ��Word�ĵ����Ĳ�����������
'����λ����SourceData��������

'д�ñ����
realEndRow = currentUseWB.Worksheets("SourceData").[A2].End(xlDown).Row
For i = 2 To realEndRow

    For j = 3 To 17 Step 2
        If j = 3 Then currentUseWB.Worksheets("SourceData").Cells(i, j).Value = "��ѯ"
        If j = 5 Then currentUseWB.Worksheets("SourceData").Cells(i, j).Value = "ռ��ѯ�ٷֱ�"
        If j = 7 Then currentUseWB.Worksheets("SourceData").Cells(i, j).Value = "����"
        If j = 9 Then currentUseWB.Worksheets("SourceData").Cells(i, j).Value = "ռ����ٷֱ�"
        If j = 11 Then currentUseWB.Worksheets("SourceData").Cells(i, j).Value = "Ͷ��"
        If j = 13 Then currentUseWB.Worksheets("SourceData").Cells(i, j).Value = "ռͶ�߰ٷֱ�"
        If j = 15 Then currentUseWB.Worksheets("SourceData").Cells(i, j).Value = currentUseWB.Worksheets("SourceData").Cells(i, 1).Value
        If j = 17 Then currentUseWB.Worksheets("SourceData").Cells(i, j).Value = "ռ�ܸ����ٷֱ�"
    Next

Next



'ͳ�Ƶ�endRowΪֹ��������������¼�����

For i = 2 To realEndRow

    For j = 4 To 16 Step 4
        currentUseWB.Worksheets("SourceData").Cells(i, j).Value = _
        Application.WorksheetFunction.CountIfs(currentUseWB.Worksheets("Sheet1").Range("D:D"), currentUseWB.Worksheets("SourceData").Cells(i, j - 1).Value, _
        currentUseWB.Worksheets("Sheet1").Range("E:E"), currentUseWB.Worksheets("SourceData").Cells(i, 1).Value)
    Next
    

Next

'=========================
ctGreen = 0
ctYellow = 0
ctRed = 0
ctZixun = 0
ctXinli = 0
ctTousu = 0

With currentUseWB.Worksheets("Sheet1")

For i = 2 To .[A65536].End(xlUp).Row
    If Trim(.Range("C" & i).Value) = "��" Then ctGreen = ctGreen + 1
    If Trim(.Range("C" & i).Value) = "��" Then ctYellow = ctYellow + 1
    If Trim(.Range("C" & i).Value) = "��" Then ctRed = ctRed + 1
    If Trim(.Range("D" & i).Value) = "��ѯ" Then ctZixun = ctZixun + 1
    If Trim(.Range("D" & i).Value) = "Ͷ��" Then ctTousu = ctTousu + 1
    If Trim(.Range("D" & i).Value) = "����" Then ctXinli = ctXinli + 1
Next

End With

'=========================


For i = 2 To realEndRow

    For j = 6 To 14 Step 4
    
    If j = 6 Then currentUseWB.Worksheets("SourceData").Cells(i, j).Value = Format(currentUseWB.Worksheets("SourceData").Cells(i, j - 2).Value / ctZixun, "0.00%")
    If j = 10 Then currentUseWB.Worksheets("SourceData").Cells(i, j).Value = Format(currentUseWB.Worksheets("SourceData").Cells(i, j - 2).Value / ctXinli, "0.00%")
    If j = 14 Then currentUseWB.Worksheets("SourceData").Cells(i, j).Value = Format(currentUseWB.Worksheets("SourceData").Cells(i, j - 2).Value / ctTousu, "0.00%")
    Next
Next

Set hiDict = CreateObject("scripting.dictionary")
hiDict.Add "��ѯ", ctZixun
hiDict.Add "����", ctXinli
hiDict.Add "Ͷ��", ctTousu

numOfAllCases = currentUseWB.Worksheets("Sheet1").[A65536].End(xlUp).Row - 1
For i = 2 To realEndRow

        currentUseWB.Worksheets("SourceData").Cells(i, 16).Value = _
        Application.WorksheetFunction.CountIfs(currentUseWB.Worksheets("Sheet1").Range("E:E"), currentUseWB.Worksheets("SourceData").Cells(i, 15).Value)
    currentUseWB.Worksheets("SourceData").Cells(i, 18).Value = Format(currentUseWB.Worksheets("SourceData").Cells(i, 16).Value / numOfAllCases, "0.00%")
    
Next



'===========================================

Set pieChart = currentUseWB.Charts.Add(after:=currentUseWB.Worksheets("SourceData"))
pieChart.Name = "PieChart"
pieChart.ChartType = xl3DPieExploded
pieChart.SetSourceData Source:=currentUseWB.Sheets("SourceData").Range("A1:B" & endRow)
pieChart.SeriesCollection(1).Select
pieChart.SeriesCollection(1).ApplyDataLabels
pieChart.PlotArea.Select
pieChart.ChartArea.Select

Set barChart = currentUseWB.Charts.Add(after:=currentUseWB.Worksheets("SourceData"))
barChart.Name = "Gender"
barChart.ChartType = xlColumnClustered
barChart.SetSourceData Source:=currentUseWB.Sheets("SourceData").Range("A" & genderStartRow & ":B" & (genderStartRow + d1.Count))
barChart.SeriesCollection(1).ApplyDataLabels

Set barChart1 = currentUseWB.Charts.Add(after:=currentUseWB.Worksheets("SourceData"))
barChart1.Name = "InMethod"
barChart1.ChartType = xlColumnClustered
barChart1.SetSourceData Source:=currentUseWB.Sheets("SourceData").Range("A" & inMethodStartRow & ":B" & (inMethodStartRow + d2.Count))
barChart1.SeriesCollection(1).ApplyDataLabels


MsgBox "�ɹ�������һ����ͼ��������״ͼ����ע�����������״ͼ������ֻ��һ�У�����ֻ���л���ֻ��QQ���룩������״ͼ�ĸ�ʽ���������⣬��Ҫ�ֹ��޸ĸ�ʽ"

End Sub

Sub mainCreateWordDoc(control As IRibbonControl)


mainCreatePieChart1

Set currentUseWB = ActiveWorkbook

Dim f$
f = Dir(currentUseWB.Path & "\���߽׶��Ա���ģ��.docx")
If f = "" Then f = Dir(currentUseWB.Path & "\���߽׶��Ա���ģ��.doc")
If f = "" Then
    MsgBox "�����ڱ�Excel�ļ������ļ�����û���ҵ�ָ���Ľ׶��Ա���ģ���ļ������߽׶��Ա���ģ��.docx�������ȷ���˳�����"
    Exit Sub
End If


Dim sht As Worksheet

Application.DisplayAlerts = False
On Error Resume Next
currentUseWB.Worksheets("ToWordDoc").Delete
currentUseWB.Worksheets("pie").Delete
currentUseWB.Worksheets("dgender").Delete
currentUseWB.Worksheets("dinmethod").Delete
On Error GoTo 0

Application.DisplayAlerts = True

Set sht = currentUseWB.Worksheets.Add(after:=currentUseWB.Sheets(currentUseWB.Sheets.Count))

sht.Name = "ToWordDoc"

With currentUseWB.Worksheets("ToWordDoc")
    .[A1].Value = "λ��˵��"
    .[A1].Interior.Color = vbYellow
    .[A2].Value = "HRC���"
    .[A2].Interior.Color = vbGreen
    .[A3].Value = "ֵ"
    .[A3].Interior.Color = vbCyan
    .[A4].Value = "λ��˵��"
    .[A4].Interior.Color = vbYellow
    .[A5].Value = "HRC���"
    .[A5].Interior.Color = vbGreen
    .[A6].Value = "ֵ"
    .[A6].Interior.Color = vbCyan
    .[A7].Value = "λ��˵��"
    .[A7].Interior.Color = vbYellow
    .[A8].Value = "HRC���"
    .[A8].Interior.Color = vbGreen
    .[A9].Value = "ֵ"
    .[A9].Interior.Color = vbCyan
    
    .[B1].Value = "��������"
    .[B2].Value = "HRC00"
    .[C1].Value = "��ʼ��"
    .[C2].Value = "HRC01"
    .[d1].Value = "��ʼ��"
    .[d2].Value = "HRC02"
    .[E1].Value = "��ֹ��"
    .[E2].Value = "HRC03"
    .[F1].Value = "��ֹ��"
    .[F2].Value = "HRC04"
    .[G1].Value = "��ʼ��"
    .[G2].Value = "HRC05"
    .[H1].Value = "��ʼ��"
    .[H2].Value = "HRC06"
    .[I1].Value = "��ֹ��"
    .[I2].Value = "HRC07"
    .[J1].Value = "��ֹ��"
    .[J2].Value = "HRC08"
    .[K1].Value = "��������"
    .[K2].Value = "HRC09"
    .[L1].Value = "�����������"
    .[L2].Value = "HRC10"
    .[M1].Value = "��ѯ�������"
    .[M2].Value = "HRC11"
    .[N1].Value = "ռ���������ٷֱ�"
    .[N2].Value = "HRC12"
    .[O1].Value = "�����������"
    .[O2].Value = "HRC13"
    .[P1].Value = "ռ���������ٷֱ�"
    .[P2].Value = "HRC14"
    .[Q1].Value = "Ͷ���������"
    .[Q2].Value = "HRC14Dot5"
    .[R1].Value = "ռ���������ٷֱ�"
    .[R2].Value = "HRC14Dot6"
    .[B4].Value = "��ɫ������"
    .[B5].Value = "HRC15"
    .[C4].Value = "��ɫ������"
    .[C5].Value = "HRC16"
    .[D4].Value = "��ɫ������"
    .[D5].Value = "HRC17"
    .[E4].Value = "�Ѿ����������"
    .[E5].Value = "HRC18"
    .[F4].Value = "����ٷֱ�"
    .[F5].Value = "HRC19"
    .[G4].Value = "δ���������"
    .[G5].Value = "HRC20"
    .[H4].Value = "δ����ٷֱ�"
    .[H5].Value = "HRC21"
    .[I4].Value = "��ʼ��"
    .[I5].Value = "HRC22"
    .[J4].Value = "��ʼ��"
    .[J5].Value = "HRC23"
    .[K4].Value = "��ֹ��"
    .[K5].Value = "HRC24"
    .[L4].Value = "��ֹ��"
    .[L5].Value = "HRC25"
    .[M4].Value = "4���������֮һ"
    .[M5].Value = "HRC26"
    .[N4].Value = "4���������֮��"
    .[N5].Value = "HRC27"
    .[O4].Value = "4���������֮��"
    .[O5].Value = "HRC28"
    .[P4].Value = "4���������֮��"
    .[P5].Value = "HRC29"
    .[B7].Value = "���ܴ��ڵĵ�5���������"
    .[B8].Value = "HRC30"
    .[C7].Value = "���ܴ��ڵĵ�6���������"
    .[C8].Value = "HRC31"
    .[D7].Value = "���ܴ��ڵĵ�7���������"
    .[D8].Value = "HRC32"
    .[E7].Value = "���ܴ��ڵĵ�8���������"
    .[E8].Value = "HRC33"
    
    .Columns("A:S").AutoFit
End With

IncludeFacCode = currentUseWB.Worksheets("Sheet1").[B2].Value
HRC00 = Trim(Left(IncludeFacCode, InStr(IncludeFacCode, "-") - 1))

IncludeStartYearAndMonth = currentUseWB.Worksheets("Sheet1").[A2].Value
HRC01 = Trim(Left(IncludeStartYearAndMonth, InStr(IncludeStartYearAndMonth, "��") - 1))


HRC02 = Mid(IncludeStartYearAndMonth, InStr(IncludeStartYearAndMonth, "��") + 1, InStr(IncludeStartYearAndMonth, "��") - InStr(IncludeStartYearAndMonth, "��") - 1)

IncludeEndYearAndMonth = currentUseWB.Worksheets("Sheet1").[A65536].End(xlUp).Value
HRC03 = Trim(Left(IncludeEndYearAndMonth, InStr(IncludeEndYearAndMonth, "��") - 1))

HRC04 = Mid(IncludeEndYearAndMonth, InStr(IncludeEndYearAndMonth, "��") + 1, InStr(IncludeEndYearAndMonth, "��") - InStr(IncludeEndYearAndMonth, "��") - 1)

HRC05 = HRC01
HRC06 = HRC02
HRC07 = HRC03
HRC08 = HRC04

HRC09 = currentUseWB.Worksheets("Sheet1").[A65536].End(xlUp).Row - 1

HRC10 = currentUseWB.Worksheets("SourceData").[A2].End(xlDown).Row - 1

ctGreen = 0
ctYellow = 0
ctRed = 0
ctZixun = 0
ctXinli = 0
ctTousu = 0

With currentUseWB.Worksheets("Sheet1")

For i = 2 To .[A65536].End(xlUp).Row
    If Trim(.Range("C" & i).Value) = "��" Then ctGreen = ctGreen + 1
    If Trim(.Range("C" & i).Value) = "��" Then ctYellow = ctYellow + 1
    If Trim(.Range("C" & i).Value) = "��" Then ctRed = ctRed + 1
    If Trim(.Range("D" & i).Value) = "��ѯ" Then ctZixun = ctZixun + 1
    If Trim(.Range("D" & i).Value) = "Ͷ��" Then ctTousu = ctTousu + 1
    If Trim(.Range("D" & i).Value) = "����" Then ctXinli = ctXinli + 1
Next

End With

HRC11 = ctZixun
HRC12 = Format(ctZixun / HRC09, "0.00%")

HRC13 = ctXinli
HRC14 = Format(ctXinli / HRC09, "0.00%")

HRC14Dot5 = ctTousu
HRC14Dot6 = Format(ctTousu / HRC09, "0.00%")

HRC15 = ctGreen
HRC16 = ctYellow
HRC17 = ctRed

HRC20 = InputBox(prompt:="������δ�������������������Ѿ�ȫ���������˴�����0��������ֱ�ӵ��ȷ��")

HRC20 = Val(HRC20)

HRC21 = Format(HRC20 / HRC09, "0.00%")

HRC18 = HRC09 - HRC20
HRC19 = Format(HRC18 / HRC09, "0.00%")

HRC22 = HRC01
HRC23 = HRC02
HRC24 = HRC03
HRC25 = HRC04

HRC26 = currentUseWB.Worksheets("SourceData").[A2].Value
HRC27 = currentUseWB.Worksheets("SourceData").[A3].Value
HRC28 = currentUseWB.Worksheets("SourceData").[A4].Value
HRC29 = currentUseWB.Worksheets("SourceData").[A5].Value
If currentUseWB.Worksheets("SourceData").[B5].Value = currentUseWB.Worksheets("SourceData").[B6].Value Then
    If currentUseWB.Worksheets("SourceData").[B6].Value = currentUseWB.Worksheets("SourceData").[B7].Value Then
        If currentUseWB.Worksheets("SourceData").[B7].Value = currentUseWB.Worksheets("SourceData").[B8].Value Then
            If currentUseWB.Worksheets("SourceData").[B8].Value = currentUseWB.Worksheets("SourceData").[B9].Value Then
                HRC30 = currentUseWB.Worksheets("SourceData").[A6].Value
                HRC31 = currentUseWB.Worksheets("SourceData").[A7].Value
                HRC32 = currentUseWB.Worksheets("SourceData").[A8].Value
                HRC33 = currentUseWB.Worksheets("SourceData").[A9].Value
            Else
                HRC30 = currentUseWB.Worksheets("SourceData").[B6].Value
                HRC31 = currentUseWB.Worksheets("SourceData").[A7].Value
                HRC32 = currentUseWB.Worksheets("SourceData").[A8].Value
            End If
        Else
            HRC30 = currentUseWB.Worksheets("SourceData").[A6].Value
            HRC31 = currentUseWB.Worksheets("SourceData").[A7].Value
        End If
    Else
        HRC30 = currentUseWB.Worksheets("SourceData").[A6].Value
    End If
End If


With currentUseWB.Worksheets("ToWordDoc")


    .[B3].Value = HRC00

    .[C3].Value = HRC01

    .[D3].Value = HRC02

    .[E3].Value = HRC03

    .[F3].Value = HRC04

    .[G3].Value = HRC05

    .[H3].Value = HRC06

    .[I3].Value = HRC07

    .[J3].Value = HRC08

    .[K3].Value = HRC09

    .[L3].Value = HRC10

    .[M3].Value = HRC11

    .[N3].Value = HRC12

    .[O3].Value = HRC13

    .[P3].Value = HRC14

    .[Q3].Value = HRC14Dot5

    .[R3].Value = HRC14Dot6

    .[B6].Value = HRC15

    .[C6].Value = HRC16

    .[D6].Value = HRC17

    .[E6].Value = HRC18

    .[F6].Value = HRC19

    .[G6].Value = HRC20

    .[H6].Value = HRC21

    .[I6].Value = HRC22

    .[J6].Value = HRC23

    .[K6].Value = HRC24

    .[L6].Value = HRC25

    .[M6].Value = HRC26

    .[N6].Value = HRC27

    .[O6].Value = HRC28

    .[P6].Value = HRC29

    .[B9].Value = HRC30

    .[C9].Value = HRC31

    .[D9].Value = HRC32

    .[E9].Value = HRC33
    
End With

'====================================

'��Excel�е�����ͼ���浽ͬһ�ļ�����
Set pie = currentUseWB.Worksheets.Add
pie.Name = "pie"
currentUseWB.Sheets("PieChart").ChartArea.Copy
currentUseWB.Sheets("pie").Paste

Set dgender = currentUseWB.Worksheets.Add
dgender.Name = "dgender"
currentUseWB.Sheets("Gender").ChartArea.Copy
currentUseWB.Sheets("dgender").Paste

Set dinmethod = currentUseWB.Worksheets.Add
dinmethod.Name = "dinmethod"
currentUseWB.Sheets("InMethod").ChartArea.Copy
currentUseWB.Sheets("dinmethod").Paste


currentUseWB.Worksheets("pie").ChartObjects(1).Chart.Export currentUseWB.Path & "\PieChart.png"
currentUseWB.Worksheets("dgender").Activate
ActiveSheet.ChartObjects(1).Chart.Export currentUseWB.Path & "\Gender.png"
currentUseWB.Worksheets("dinmethod").Activate
ActiveSheet.ChartObjects(1).Chart.Export currentUseWB.Path & "\InMethod.png"
'====================================


MsgBox "д��word�ĵ��������ݴ�����ϣ����ȷ����ʼ����Word�ĵ���ע���ƶ��Ľ׶��Ա���ģ�塾���߽׶��Ա���ģ��.docx�������ڴ��ļ����£�"

If Val(HRC30) = 0 Then
    endCellNumber = 30
ElseIf Val(HRC31) = 0 Then
    endCellNumber = 31
ElseIf Val(HRC32) = 0 Then
    endCellNumber = 32
ElseIf Val(HRC33) = 0 Then
    endCellNumber = 33
End If

Set WordObject = CreateObject("Word.Application")
currentPath = currentUseWB.Path

If Len(HRC02) = 1 Then HRC02 = "0" & HRC02
If Len(HRC04) = 1 Then HRC04 = "0" & HRC04

docName = HRC00 & " " & HRC01 & "-" & HRC03 & HRC04

HRC02 = Val(HRC02)
HRC04 = Val(HRC04)

FileCopy currentPath & "\���߽׶��Ա���ģ��.docx", currentPath & "\" & docName & ".docx"

'������HRC���������ֵ�
Dim dict
Set dict = CreateObject("Scripting.Dictionary")

dict.Add "HRC00", HRC00
dict.Add "HRC01", HRC01
dict.Add "HRC02", HRC02
dict.Add "HRC03", HRC03
dict.Add "HRC04", HRC04
dict.Add "HRC05", HRC05
dict.Add "HRC06", HRC06
dict.Add "HRC07", HRC07
dict.Add "HRC08", HRC08
dict.Add "HRC09", HRC09
dict.Add "HRC10", HRC10
dict.Add "HRC11", HRC11
dict.Add "HRC12", HRC12
dict.Add "HRC13", HRC13
dict.Add "HRC14", HRC14
dict.Add "HRC15", HRC15
dict.Add "HRC16", HRC16
dict.Add "HRC17", HRC17
dict.Add "HRC18", HRC18
dict.Add "HRC19", HRC19
dict.Add "HRC20", HRC20
dict.Add "HRC21", HRC21
dict.Add "HRC22", HRC22
dict.Add "HRC23", HRC23
dict.Add "HRC24", HRC24
dict.Add "HRC25", HRC25
dict.Add "HRC26", HRC26
dict.Add "HRC27", HRC27
dict.Add "HRC28", HRC28
dict.Add "HRC29", HRC29
dict.Add "HRC30", HRC30
dict.Add "HRC31", HRC31
dict.Add "HRC32", HRC32
dict.Add "HRC33", HRC33
dict.Add "HRC14Dot5", HRC14Dot5
dict.Add "HRC14Dot6", HRC14Dot6

'=============
'д��word�����������Ŀ��
numOfAllCases = currentUseWB.Worksheets("Sheet1").[A65536].End(xlUp).Row - 1
realEndRow = currentUseWB.Worksheets("SourceData").[A2].End(xlDown).Row

  currentUseWB.Worksheets("SourceData").Range("C" & (realEndRow + 1)).Value = "��ѯ��������"
  currentUseWB.Worksheets("SourceData").Range("D" & (realEndRow + 1)).Value = ctZixun
  currentUseWB.Worksheets("SourceData").Range("E" & (realEndRow + 1)).Value = "ռ�ܸ������ٷֱ�"
   currentUseWB.Worksheets("SourceData").Range("F" & (realEndRow + 1)).Value = Format(ctZixun / numOfAllCases, "0.00%")

  currentUseWB.Worksheets("SourceData").Range("G" & (realEndRow + 1)).Value = "�����������"
    currentUseWB.Worksheets("SourceData").Range("H" & (realEndRow + 1)).Value = ctXinli
            currentUseWB.Worksheets("SourceData").Range("I" & (realEndRow + 1)).Value = "ռ�ܸ������ٷֱ�"
        currentUseWB.Worksheets("SourceData").Range("J" & (realEndRow + 1)).Value = Format(ctXinli / numOfAllCases, "0.00%")
    
  currentUseWB.Worksheets("SourceData").Range("K" & (realEndRow + 1)).Value = "Ͷ�߸�������"
    currentUseWB.Worksheets("SourceData").Range("L" & (realEndRow + 1)).Value = ctTousu
  currentUseWB.Worksheets("SourceData").Range("M" & (realEndRow + 1)).Value = "ռ�ܸ������ٷֱ�"
    currentUseWB.Worksheets("SourceData").Range("N" & (realEndRow + 1)).Value = Format(ctTousu / numOfAllCases, "0.00%")
  
'=============



With WordObject

 .Documents.Open (currentPath & "\" & docName & ".docx")
.Visible = False
    With .Selection.Find
        For i = 0 To 33
            If Len(i) = 1 Then
                si = "0" & i
            Else
                si = i
            End If
            siIndex = "HRC" & si
            .Text = siIndex
            .Replacement.Text = dict.Item(siIndex)
            .Execute Replace:=2 'ȫ���滻
        Next
        
            .Text = "HRC40"
            .Replacement.Text = dict.Item("HRC14Dot5")
            .Execute Replace:=2 'ȫ���滻
            .Text = "HRC41"
            .Replacement.Text = dict.Item("HRC14Dot6")
            .Execute Replace:=2 'ȫ���滻
            
            
            
            
         Set hiDict = CreateObject("scripting.dictionary")
         endRow = currentUseWB.Worksheets("SourceData").Range("s2").Value
         ky = 1
         For i = 2 To endRow
            For j = 4 To 18 Step 2
                temp = currentUseWB.Worksheets("SourceData").Cells(i, j).Value
                If ky Mod 2 = 0 Then temp = Format(temp, "0.00%")
                hiDict.Add ky, temp
                ky = ky + 1
            Next
         Next
         
        For i = 1 To 40
            If Len(i) = 1 Then
                si = "0" & i
            Else
                si = i
            End If
            siIndex = "Four" & si
            .Text = siIndex
            .Replacement.Text = hiDict.Item(i)
            .Execute Replace:=2 'ȫ���滻
        Next
    
    End With
    
    
Rem ������δ��ɵĹ���

'�����Ĳ��ֵ����ֲ���

'�������͵������ֵ�ͼ��


.Selection.Find.Text = "��ӳ���ĸ����������"
.Selection.Find.Execute
.Selection.MoveRight 1
.Selection.InlineShapes.AddPicture Filename:= _
         currentPath & "\PieChart.png", _
         LinkToFile:=False, SaveWithDocument:=True

.Selection.Find.Text = "���߸�����Ů��������ͼ"
.Selection.Find.Execute
.Selection.MoveRight 1
.Selection.InlineShapes.AddPicture Filename:= _
         currentPath & "\Gender.png", _
         LinkToFile:=False, SaveWithDocument:=True
         
         
.Selection.Find.Text = "���߸������뷽ʽ������"
.Selection.Find.Execute
.Selection.MoveRight 1
.Selection.InlineShapes.AddPicture Filename:= _
         currentPath & "\InMethod.png", _
         LinkToFile:=False, SaveWithDocument:=True
        
    

       
       
       '����word�ĵ��ʼ�ı��
        With .ActiveDocument.Tables(1) 'Word���
        
                '����������������
                j = 8
                For i = 2 To realEndRow
                    If currentUseWB.Worksheets("SourceData").Cells(i, j).Value <> 0 Then
                       .Cell(2, 2) = currentUseWB.Worksheets("SourceData").Cells(i, 1).Value
                       .Cell(2, 3) = currentUseWB.Worksheets("SourceData").Cells(i, j).Value
                       .Cell(2, 4) = Format(currentUseWB.Worksheets("SourceData").Cells(i, j).Value / numOfAllCases, "0.00%")
                       .Cell(2, 5) = Format(currentUseWB.Worksheets("SourceData").Cells(realEndRow + 1, j + 2).Value, "0.00%") '�˴�������ʾ��Ϊ�ٷֱ�
                    End If
                Next
                
                '������ѯ��������
                j = 4
                m = 3
                For i = 2 To realEndRow
                    If currentUseWB.Worksheets("SourceData").Cells(i, j).Value <> 0 Then
                       .Cell(m, 2) = currentUseWB.Worksheets("SourceData").Cells(i, 1).Value
                       .Cell(m, 3) = currentUseWB.Worksheets("SourceData").Cells(i, j).Value
                       .Cell(m, 4) = Format(currentUseWB.Worksheets("SourceData").Cells(i, j).Value / numOfAllCases, "0.00%")
                       '.Cell(m, 5) = currentUseWB.Worksheets("SourceData").Cells(realEndRow, j + 2).Value
                       m = m + 1
                    End If
                Next
                 .Cell(3, 5) = Format(currentUseWB.Worksheets("SourceData").Cells(realEndRow + 1, j + 2).Value, "0.00%")
                 
                 '����Ͷ���¼�����
                 j = 12
                 m = 17
                For i = 2 To realEndRow
                    If currentUseWB.Worksheets("SourceData").Cells(i, j).Value <> 0 Then
                       .Cell(m, 2) = currentUseWB.Worksheets("SourceData").Cells(i, 1).Value
                       .Cell(m, 3) = currentUseWB.Worksheets("SourceData").Cells(i, j).Value
                       .Cell(m, 4) = Format(currentUseWB.Worksheets("SourceData").Cells(i, j).Value / numOfAllCases, "0.00%")
                       '.Cell(m, 5) = currentUseWB.Worksheets("SourceData").Cells(realEndRow, j + 2).Value
                       m = m + 1
                    End If
                Next
                
                .Cell(17, 5) = Format(currentUseWB.Worksheets("SourceData").Cells(realEndRow + 1, j + 2).Value, "0.00%")
            

        End With


End With

WordObject.Documents.Save

WordObject.Quit

Set WordObject = Nothing

'ɾ���ļ����µ�ͼƬ
Kill currentPath & "\PieChart.png"
Kill currentPath & "\Gender.png"
Kill currentPath & "\InMethod.png"

currentUseWB.Worksheets("Sheet1").Activate
currentUseWB.Worksheets("Sheet1").[A1].Select
MsgBox "������ϣ����ڱ��ļ������ļ������ҵ��׶��Ա����Word�ĵ���"

End Sub
