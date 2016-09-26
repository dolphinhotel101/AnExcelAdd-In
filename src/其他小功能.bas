Attribute VB_Name = "����С����"
'Date: 2016.8.1-2016.9.18
'Author: Vinson Wei
'Purpose: Aditional generic functions
Public Sub SumAllToOne(control As IRibbonControl)
Dim f$
Dim destinationSht, sht As Worksheet
Set currentUseWB = ActiveWorkbook
f = Dir(currentUseWB.Path & "\*.*")
If f = currentUseWB.Name Then f = Dir
If f = "" Then
    MsgBox "���ļ������������ļ���"
    Exit Sub
End If

For Each sht In currentUseWB.Worksheets
    If sht.Name = "Question Sheet" Then
        Set destinationSht = currentUseWB.Worksheets("Question Sheet")
        Exit For
    Else
        Set destinationSht = currentUseWB.Worksheets(1)
    End If
    
Next

On Error GoTo 0

Do
    If f <> currentUseWB.Name Then
        Set WB = Workbooks.Open(currentUseWB.Path & "\" & f)
        For Each sht In WB.Worksheets
            sht.Copy before:=destinationSht
        Next
        WB.Close False
    End If
    f = Dir
Loop Until f = ""
MsgBox "������ϡ�"
End Sub

Sub NoResOpenCopyCloseOneiMonthlyReport(control As IRibbonControl)


Dim f$, WB As Workbook, pw$, loc$, sht As Worksheet, nameList

Set currentUseWB = ActiveWorkbook
On Error Resume Next
Application.DisplayAlerts = False
currentUseWB.Worksheets("Sheet2").Delete
currentUseWB.Worksheets("Sheet3").Delete
Application.DisplayAlerts = True
On Error GoTo 0
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
f = Dir(currentUseWB.Path & "\*.xls*")
Do

        '��ѯ�����ļ������±��ļ�

        If f <> currentUseWB.Name Then
        
        Set WB = Workbooks.Open(Filename:=currentUseWB.Path & "\" & f)
        
        
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
        WB.Worksheets(1).Range("A3").Copy _
        currentUseWB.Worksheets("Sheet1").Range("B" & iLInSheet1)
        WB.Worksheets(1).Range("C3").Copy _
        currentUseWB.Worksheets("Sheet1").Range("C" & iLInSheet1)
        EventAndQuestion = WB.Worksheets(1).Range("A5").Value
        midStart = InStr(EventAndQuestion, ":")
        If midStart = 0 Then midStart = InStr(EventAndQuestion, "��")
        If midStart = 0 Then
            MsgBox "��" & WB.Name & "�ļ����������������û�з������Ļ���Ӣ��ð�ţ����ȷ���˳��ļ���"
            Exit Sub
        End If
        
        EventString = Trim(Mid(EventAndQuestion, 1, midStart - 1))
        QuestionString = Trim(Mid(EventAndQuestion, midStart + 1, 100))
        
        currentUseWB.Worksheets("Sheet1").Range("D" & iLInSheet1).Value = EventString
        currentUseWB.Worksheets("Sheet1").Range("E" & iLInSheet1).Value = QuestionString
                
        WB.Worksheets(1).Range("K3").Copy _
        currentUseWB.Worksheets("Sheet1").Range("F" & iLInSheet1)
                WB.Worksheets(1).Range("F3").Copy _
        currentUseWB.Worksheets("Sheet1").Range("G" & iLInSheet1)
                        
        WB.Worksheets(1).Range("B5").Copy _
        currentUseWB.Worksheets("Sheet1").Range("H" & iLInSheet1)
        
                WB.Worksheets(1).Range("B3").Copy _
        currentUseWB.Worksheets("Sheet1").Range("A" & iLInSheet1)
'
'        WB.Worksheets(1).Range("F3").Copy _
'        currentUseWB.Worksheets("Sheet1").Range("G" & iLInSheet1)
'        '��Case Sheet���н���ͨ��ʽ�������Ա���˹���
'        WB.Worksheets(1).Range("F2", "G" & (nameList.Count + 1)).Copy _
'        currentUseWB.Worksheets("Sheet1").Range("F" & iLInSheet1)
'
        'д������
'        For i = iLInSheet1 To (iRInSheet1 - 1)
'        currentUseWB.Worksheets("Sheet1").Range("A" & i).Value = "'" & year & "��" & iMonth & "��"
'        iLInSheet1 = iLInSheet1 + 1
'        Next
        
        endCode = currentUseWB.Worksheets("Sheet1").Range("B" & (iLInSheet1 - 1)).Value
        
'        If Trim(endCode) <> nameList(nameList.Count - 1) Then
'            MsgBox "ע�⣬���ڷ�����һ��������������Ҳ�" & year & "��" & iMonth & "�µ��±���" _
'            & "��ĳ����������������������������������һ��������ţ�����" & "�����˵���ʱ������λ�����ȷ�������򽫳����Զ������λ��"
'            GoTo iLNotEqualToiR
'        End If
        
        '�����������￪ʼ
iLEqualToiR:
        iLInSheet1 = iRInSheet1
        
        WB.Close False
        
        End If
        
        f = Dir

Loop Until f = ""

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
MsgBox "������ϡ�"

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
currentUseWB.Worksheets("Sheet1").Range("A" & i).Value = "�ִ�����" '"'" &   "��" & iMonth & ""
iLInSheet1 = iLInSheet1 + 1
Next
MsgBox "Ok����λ�����ѽ������������������С�"
GoTo iLEqualToiR


End Sub
' Sub NoResCreatePivotTable(control As IRibbonControl)
' On Error Resume Next
'     Application.DisplayAlerts = False
'     currentUseWB.Sheets("PivotSheet").Delete
'     Application.DisplayAlerts = False
' On Error GoTo 0


' Dim pivotSheet As Worksheet, rg As Range, endCell As Range
' Set currentUseWB = ActiveWorkbook
' '��������Դ
' Set pivotSheet = currentUseWB.Worksheets.Add(after:=currentUseWB.Worksheets("Sheet1"))
' pivotSheet.Name = "PivotSheet"
' Set endCell = currentUseWB.Worksheets("Sheet1").Range("E2").End(xlDown)
' currentUseWB.Worksheets("Sheet1").Activate
' endCell.Select
' Set rg = Range(Range("D1"), endCell)

'  currentUseWB.PivotCaches.Create(SourceType:=xlDatabase, SourceData:= _
'         rg, Version:=xlPivotTableVersion10).CreatePivotTable _
'         TableDestination:="PivotSheet!R3C1", TableName:="PivotTable", DefaultVersion:= _
'         xlPivotTableVersion10
'     Worksheets("PivotSheet").Select
'     currentUseWB.ShowPivotTableFieldList = True
'     With currentUseWB.Worksheets("PivotSheet").PivotTables("PivotTable").PivotFields("�¼�����")
'         .Orientation = xlRowField
'         .Position = 1
'     End With
'         currentUseWB.Worksheets("PivotSheet").PivotTables("PivotTable").AddDataField currentUseWB.Worksheets("PivotSheet").PivotTables("PivotTable" _
'         ).PivotFields("�������"), "������������", xlCount
'     With currentUseWB.Worksheets("PivotSheet").PivotTables("PivotTable").PivotFields("�������")
'         .Orientation = xlColumnField
'         .Position = 1
'     End With

'     currentUseWB.ShowPivotTableFieldList = False
    
'     MsgBox "����͸�ӱ��������"
' End Sub

 Sub NoResCreatePieChart(control As IRibbonControl)
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
    If ctZixun = 0 Then GoTo Step1
    If j = 6 Then currentUseWB.Worksheets("SourceData").Cells(i, j).Value = Format(currentUseWB.Worksheets("SourceData").Cells(i, j - 2).Value / ctZixun, "0.00%")
Back1:
    If ctXinli = 0 Then GoTo Step2
    If j = 10 Then currentUseWB.Worksheets("SourceData").Cells(i, j).Value = Format(currentUseWB.Worksheets("SourceData").Cells(i, j - 2).Value / ctXinli, "0.00%")
Back2:
    If ctTousu = 0 Then GoTo Step3
    If j = 14 Then currentUseWB.Worksheets("SourceData").Cells(i, j).Value = Format(currentUseWB.Worksheets("SourceData").Cells(i, j - 2).Value / ctTousu, "0.00%")
Back3:
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
    
'=====================================================

MsgBox "�ɹ�������һ����ͼ��������״ͼ����ע�����������״ͼ������ֻ��һ�У�����ֻ���л���ֻ��QQ���룩������״ͼ�ĸ�ʽ���������⣬��Ҫ�ֹ��޸ĸ�ʽ"

Exit Sub

Step1:
   If j = 6 Then currentUseWB.Worksheets("SourceData").Cells(i, j).Value = 0
 GoTo Back1
Step2:
    If j = 10 Then currentUseWB.Worksheets("SourceData").Cells(i, j).Value = 0
 GoTo Back2
Step3:
    If j = 14 Then currentUseWB.Worksheets("SourceData").Cells(i, j).Value = 0
GoTo Back3

End Sub
