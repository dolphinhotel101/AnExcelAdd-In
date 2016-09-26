Attribute VB_Name = "�±��Զ������ű�v1"
'Date: 2016.8.1-2016.9.18
'Author: Vinson Wei
'Purpose: Automate the process of making a monthly report

Dim numOldStart, numOldEnd As String
Dim numNewStart, numNewEnd As String
Dim factory As String
Dim currentUseWB
Dim status As Integer
Dim i, lenOfi As Integer
Dim ni As Integer
Dim sIndex As String
Dim WB As Workbook
Dim CaseSheet, QuestionSheet, QuestionSheetInVertical, PerspectiveView As Worksheet


Sub ExecuteAllStepsAtOnce(control As IRibbonControl)

Application.DisplayAlerts = False

status = 0
Call Initialization(status)

If status <> 0 Then
    Select Case status
        Case 1
            MsgBox "δ���빤�����룬���ȷ���˳��±�����"
        Case 2
            MsgBox "δ����������С������ţ����ȷ���˳��±�����"
        Case 3
            MsgBox "δ����������������ţ����ȷ���˳��±�����"
        Case 4
            MsgBox "δ���뱾����С������ţ����ȷ���˳��±�����"
        Case 5
            MsgBox "δ���뱾����������ţ����ȷ���˳��±�����"
    End Select
Exit Sub
End If

DeleteOldSheets
InsertNewSheets
UpdateCaseSheet
UpdateQuestionSheet
UpdateQuestionSheetInVertical
UpdatePerspectiveView
LocateALLCursorsOnA1

Application.DisplayAlerts = True

Delay (1)


MsgBox "�����Ѿ�������ϣ���ɵ������У�ɾ���������и������������뱾�����и�������������Case Sheet" _
& "���������е���Ϣ������Question Sheet������������Ϣ������Question Sheet in Vertical����������Ϣ������ѡ������͸�ӱ�" _
& "����Դ��ˢ������͸�ӱ����й������궼�Ѿ���λ��A1��Ԫ�񡣡���ע�⡾���С���Щ���Ķ�û�б��棬���ִ�еĹ������д������룬��ֱ�ӹر��ļ�����������漴�ɣ�Ȼ�����ô��ļ����¿�ʼ�±�����������������©����û�д������ֶ�������ɣ�����ֶ�����"
End Sub
Sub Initialization(ByRef status As Integer)

factory = InputBox(prompt:="���빤������", Title:="��������")          '��������

If factory = "" Then
status = 1
Exit Sub
End If

numOldStart = InputBox(prompt:="�������¸�����С���", Title:="�������¸�����С���")         '���¸ù���������С���

If numOldStart = "" Then
status = 2
Exit Sub
End If

numOldEnd = InputBox(prompt:="�������¸��������", Title:="�������¸��������")        '���¸ù������������

If numOldEnd = "" Then
status = 3
Exit Sub
End If

numNewStart = InputBox(prompt:="���뱾�¸�����С���", Title:="���뱾�¸�����С���")       '���¸ù���������С���

If numNewStart = "" Then
status = 4
Exit Sub
End If

numNewEnd = InputBox(prompt:="���뱾�¸��������", Title:="���뱾�¸��������")       '���¸ù������������

If numNewEnd = "" Then
status = 5
Exit Sub
End If

Set CaseSheet = Worksheets("Case Sheet")
Set QuestionSheet = Worksheets("Question Sheet")
Set QuestionSheetInVertical = Worksheets("Question Sheet in Vertical")
Set PerspectiveView = Worksheets("Perspective View")
Set currentUseWB = ActiveWorkbook
End Sub


Sub Delay(T As Single)
    Dim time1 As Single
    time1 = Timer
    Do
        DoEvents
    Loop While Timer - time1 < T
End Sub
Sub DeleteOldSheets() 'ɾ���������и���������

For i = Val(numOldStart) To Val(numOldEnd)
lenOfi = Len(CStr(i))
If lenOfi = 1 Then
    sIndex = factory & "-" & "00" & CStr(i)
    'ActiveSheet.[A6] = sIndex
ElseIf lenOfi = 2 Then
    sIndex = factory & "-" & "0" & CStr(i)
Else
    sIndex = factory & "-" & CStr(i)
End If
On Error Resume Next
Worksheets(sIndex).Delete
Next

End Sub
Sub InsertNewSheets() '���±��в��뱾�����и���

Application.ScreenUpdating = False


For ni = Val(numNewStart) To Val(numNewEnd)
        lenOfni = Len(CStr(ni))
        If lenOfni = 1 Then
            sIndex = factory & "-" & "00" & CStr(ni)
        ElseIf lenOfni = 2 Then
            sIndex = factory & "-" & "0" & CStr(ni)
        Else
            sIndex = factory & "-" & CStr(ni)
        End If
        f = Dir(currentUseWB.Path & "\" & "??" & sIndex & "*" & ".xls")
        If f = "" Then f = Dir(currentUseWB.Path & "\" & "??" & sIndex & "*" & ".xlsx")
        If f = "" Then
            MsgBox "û���ҵ�" & sIndex & "��������Excel������������ͬһ�ļ������Ƿ����" & sIndex & "�����ļ������û�д��ļ���" _
            & "��NAS���ƶ�Ӧ�ĸ�����ͬһ�ļ����£�����ø����ļ�����ʽ������������һ����" _
            & "���޸�Ϊ������������ͬ���ļ�����ʽ��Ȼ��رճ��򣬹رմ�Excel�ļ���ѡ�񲻱�����ģ�Ȼ�����������±���"
            Exit Sub
        End If
        Workbooks.Open (currentUseWB.Path & "\" & f)
        Set WB = ActiveWorkbook
        
        If WB.Worksheets.Count > 1 Then
            MsgBox WB.Name & "����������������1�����Ϲ�������ǰ���鿴���������ȷ���˳�����"
            Exit Sub
        End If
        
  
        If WB.Worksheets(1).Name <> sIndex Then
            MsgBox "��...�Ҳ�" & sIndex & "�����ļ��еĹ������ǩ�Ǵ�ģ����" & vbLf & "������񾭳�����(���(?)����)�����ȷ���������Զ����Խ���ĳ���ȷ�Ĺ������ǩ��"
            WB.Worksheets(1).Name = sIndex
            MsgBox "OK�������ļ��д���Ĺ������ǩ�Ѿ����ģ����ȷ�������������С�"
            
        End If
        WB.Worksheets(sIndex).Copy before:=currentUseWB.Worksheets("Question Sheet")
        If Trim(currentUseWB.Worksheets(sIndex).[E3].Value) <> factory Then
            MsgBox "Ŷ..." & sIndex & "�����ļ�����Ĺ������루Name of the Factory����E3��Ԫ��������ݲ���ȷ�����ȷ��������Զ����ġ��±����еĹ�������͡������ļ����еĹ������롣"
            currentUseWB.Worksheets(sIndex).[E3].Value = factory
            WB.Worksheets(sIndex).[E3].Value = factory
            MsgBox "OK�����±����͡������ļ����еĴ��󹤳����루Name of the Factory���Ѿ����ģ����ȷ�������������С�"
        End If
        
        endBrand = InStr(3, currentUseWB.Name, " ")
        If endBrand = 0 Then endBrand = InStr(3, currentUseWB.Name, " ")
        brand = Trim(Mid(currentUseWB.Name, 1, endBrand - 1))
        
        If Trim(currentUseWB.Worksheets(sIndex).[D3].Value) <> brand Then
            MsgBox "��.." & sIndex & "�����ļ������Ʒ�ƴ��루Brand����D3��Ԫ������ݲ���ȷ�����ȷ��������Զ����ġ��±����е�Ʒ�ƴ���͡������ļ����е�Ʒ�ƴ��롣"
            currentUseWB.Worksheets(sIndex).[D3].Value = brand
            WB.Worksheets(sIndex).[D3].Value = brand
            MsgBox "OK�����±����͡������ļ����еĴ���Ʒ�ƴ��루Brand���Ѿ����ģ����ȷ�������������С�"
        End If
        
        If Trim(currentUseWB.Worksheets(sIndex).[A3].Value) <> sIndex Then
            MsgBox "������" & sIndex & "�����ļ���ĸ�����ţ�Serial Number����A3��Ԫ��������д��󣬵��ȷ��������Զ����ġ��±����еĸ�����ź͡������ļ����еĸ�����š�"
            currentUseWB.Worksheets(sIndex).[A3].Value = sIndex
            WB.Worksheets(sIndex).[A3].Value = sIndex
            MsgBox "OK�����±����͡������ļ����еĴ��������ţ�Serial Number���Ѿ����ģ����ȷ�������������С�"
        End If
        
        WB.Close True
        


Next


Application.ScreenUpdating = True


End Sub

Sub UpdateCaseSheet() '����Case Sheet����������Ϣ
Dim iInCaseSheet, ni, lenOfni As Integer, sIndex, toSheetNum As String
Dim newSpan, oldSpan As Integer

newSpan = Val(numNewEnd) - Val(numNewStart)
oldSpan = Val(numOldEnd) - Val(numOldStart)


Rem I.1 ����Case Sheet�����������ֱ��Ǳ��¸�����������/��/��ȵ����
If (oldSpan) > (newSpan) Then
        startClearRow = newSpan + 3
        CaseSheet.Range(CStr(startClearRow) & ":65536").Clear
End If
For iInCaseSheet = 1 To (newSpan + 1)
Length = Len(CStr(iInCaseSheet))
        If Length = 1 Then
            sIndex = "00" & CStr(iInCaseSheet)
        ElseIf Length = 2 Then
            sIndex = "0" & CStr(iInCaseSheet)
        Else
            sIndex = CStr(iInCaseSheet)
        End If
        CaseSheet.Range("A" & CStr(iInCaseSheet + 1)).Value = "'" & sIndex
Next
'�ø�ʽˢ�����������ˢ��ԭ���ĸ�ʽ
CaseSheet.[A2].Copy
CaseSheet.Range("A2", "A" & CStr(newSpan + 2)).PasteSpecial Paste:=xlPasteFormats, Operation:=xlNone, _
SkipBlanks:=False, Transpose:=False

Rem I.2 ����'����'�еĳ�����
'(1)���ÿ��Ҫ���µ�toSheet������toIndex
For iInCaseSheet = 1 To (newSpan + 1)
toSheetNum = Val(numNewStart) + iInCaseSheet - 1
lenOftoSheetNum = Len(CStr(toSheetNum))
If lenOftoSheetNum = 1 Then
    toNum = "00" & CStr(toSheetNum)
    toIndex = factory & "-" & toNum
ElseIf lenOftoSheetNum = 2 Then
    toNum = "0" & CStr(toSheetNum)
    toIndex = factory & "-" & toNum
Else
    toNum = CStr(toSheetNum)
    toIndex = factory & "-" & toNum
End If

'(2)������������ʾ������,��ȡÿ��Ҫ���µĵ�Ԫ���ֵ
lengOfIndex = Len(CStr(iInCaseSheet))
If lengOfIndex = 1 Then
toNumShow = "00" & iInCaseSheet
ElseIf lengOfIndex = 2 Then
toNumShow = "0" & iInCaseSheet
Else
toNumShow = iInCaseSheet
End If

'(3)��������������׼���Ϳ��Ը��³�������
CaseSheet.Hyperlinks.Add Anchor:=CaseSheet.Range("A" & (iInCaseSheet + 1)), _
Address:="", _
SubAddress:="'" & toIndex & "'!A1", _
TextToDisplay:="'" & toNumShow
Next
'�����еĵ����������Ӹ������

Rem II����BAS��ɫ�С��������š�������š���ӳʱ�䡢��ͨ��ʽ�������Ա�
For iInCaseSheet = 1 To (newSpan + 1)
toSheetNum = Val(numNewStart) + iInCaseSheet - 1
lenOftoSheetNum = Len(CStr(toSheetNum))
If lenOftoSheetNum = 1 Then
    toNum = "00" & CStr(toSheetNum)
    toIndex = factory & "-" & toNum
ElseIf lenOftoSheetNum = 2 Then
    toNum = "0" & CStr(toSheetNum)
    toIndex = factory & "-" & toNum
Else
    toNum = CStr(toSheetNum)
    toIndex = factory & "-" & toNum
End If

'����BAS��ɫ
'������������
CaseSheet.Range("B" & CStr(iInCaseSheet + 1)).Value = Worksheets(toIndex).Range("C3").Value
'����������ɫ
CaseSheet.Range("B" & CStr(iInCaseSheet + 1)).Font.Color = Worksheets(toIndex).Range("C3").Interior.Color

'��������
CaseSheet.Range("C" & CStr(iInCaseSheet + 1)).Value = factory

'�������
CaseSheet.Range("D" & CStr(iInCaseSheet + 1)).Value = "'" & toNum

'��ӳʱ��
CaseSheet.Range("E" & CStr(iInCaseSheet + 1)).Value = Worksheets(toIndex).Range("B3").Value

'��ͨ��ʽ
CaseSheet.Range("F" & CStr(iInCaseSheet + 1)).Value = Worksheets(toIndex).Range("K3").Value

'�����Ա�
CaseSheet.Range("G" & CStr(iInCaseSheet + 1)).Value = Worksheets(toIndex).Range("F3").Value
Next

'���������롢������š���ӳʱ�䡢�����Ա�ˢ��ԭ���ĸ�ʽ
'��Ҫ���ڷ�ֹnewSpan>oldSpan������¶���������������û�к��ʵĸ�ʽ
'BAS��ɫ�бȽ����⣬�ݲ�����
CaseSheet.Range("C2").Copy

CaseSheet.Range("C2", "C" & CStr(newSpan + 2)).PasteSpecial Paste:=xlPasteFormats, Operation:=xlNone, _
SkipBlanks:=False, Transpose:=False

CaseSheet.Range("D2").Copy
CaseSheet.Range("D2", "D" & CStr(newSpan + 2)).PasteSpecial Paste:=xlPasteFormats, Operation:=xlNone, _
SkipBlanks:=False, Transpose:=False


CaseSheet.Range("E2").Copy
CaseSheet.Range("E2", "E" & CStr(newSpan + 2)).PasteSpecial Paste:=xlPasteFormats, Operation:=xlNone, _
SkipBlanks:=False, Transpose:=False


CaseSheet.Range("F2").Copy
CaseSheet.Range("F2", "F" & CStr(newSpan + 2)).PasteSpecial Paste:=xlPasteFormats, Operation:=xlNone, _
SkipBlanks:=False, Transpose:=False

CaseSheet.Range("G2").Copy
CaseSheet.Range("G2", "G" & CStr(newSpan + 2)).PasteSpecial Paste:=xlPasteFormats, Operation:=xlNone, _
SkipBlanks:=False, Transpose:=False

'����BAS��ɫ�е�����
If (CaseSheet.Range("B2").Value Like "*e*") Then
    With CaseSheet.Range("B2", "B" & CStr(newSpan + 2))
        .Font.Name = "Arial"
        .Font.Size = 11
        .HorizontalAlignment = xlCenter
        .VerticalAlignment = xlCenter
        .WrapText = True
        .Orientation = 0
        .AddIndent = False
        .IndentLevel = 0
        .ShrinkToFit = False
        .ReadingOrder = xlContext
        .MergeCells = False
    End With
Else
    With CaseSheet.Range("B2", "B" & CStr(newSpan + 2))
        .HorizontalAlignment = xlCenter
        .VerticalAlignment = xlCenter
        .WrapText = True
        .Orientation = 0
        .AddIndent = False
        .IndentLevel = 0
        .ShrinkToFit = False
        .ReadingOrder = xlContext
        .MergeCells = False
        .Font.Name = "����"
        .Font.Size = 10
    End With
End If


Rem BAS��ɫ�д���
 CaseSheet.Range("B2", "B" & CStr(newSpan + 2)).Borders(xlDiagonalDown).LineStyle = xlNone
    CaseSheet.Range("B2", "B" & CStr(newSpan + 2)).Borders(xlDiagonalUp).LineStyle = xlNone
    With CaseSheet.Range("B2", "B" & CStr(newSpan + 2)).Borders(xlEdgeLeft)
        .LineStyle = xlContinuous
        .ColorIndex = 0
        .TintAndShade = 0
        .Weight = xlThin
    End With
    With CaseSheet.Range("B2", "B" & CStr(newSpan + 2)).Borders(xlEdgeTop)
        .LineStyle = xlContinuous
        .ColorIndex = 0
        .TintAndShade = 0
        .Weight = xlThin
    End With
    With CaseSheet.Range("B2", "B" & CStr(newSpan + 2)).Borders(xlEdgeBottom)
        .LineStyle = xlContinuous
        .ColorIndex = 0
        .TintAndShade = 0
        .Weight = xlThin
    End With
    With CaseSheet.Range("B2", "B" & CStr(newSpan + 2)).Borders(xlEdgeRight)
        .LineStyle = xlContinuous
        .ColorIndex = 0
        .TintAndShade = 0
        .Weight = xlThin
    End With
    With CaseSheet.Range("B2", "B" & CStr(newSpan + 2)).Borders(xlInsideVertical)
        .LineStyle = xlContinuous
        .ColorIndex = 0
        .TintAndShade = 0
        .Weight = xlThin
    End With
    With CaseSheet.Range("B2", "B" & CStr(newSpan + 2)).Borders(xlInsideHorizontal)
        .LineStyle = xlContinuous
        .ColorIndex = 0
        .TintAndShade = 0
        .Weight = xlThin
    End With
Rem BAS��ɫ�д���

End Sub

Sub UpdateQuestionSheet()
'����QuesttionSheet
Dim newSpan, oldSpan As Integer

newSpan = Val(numNewEnd) - Val(numNewStart)
oldSpan = Val(numOldEnd) - Val(numOldStart)

Rem ���¸��������
If (oldSpan) > (newSpan) Then
        startClearRow = newSpan + 3
        QuestionSheet.Range(CStr(startClearRow) & ":65536").Clear
End If
For iInCaseSheet = 1 To (newSpan + 1)
                toSheetNum = Val(numNewStart) + iInCaseSheet - 1
                lenOftoSheetNum = Len(CStr(toSheetNum))
                If lenOftoSheetNum = 1 Then
                    toNum = "00" & CStr(toSheetNum)
                    toIndex = factory & "-" & toNum
                ElseIf lenOftoSheetNum = 2 Then
                    toNum = "0" & CStr(toSheetNum)
                    toIndex = factory & "-" & toNum
                Else
                    toNum = CStr(toSheetNum)
                    toIndex = factory & "-" & toNum
                End If
                QuestionSheet.Range("A" & CStr(iInCaseSheet + 1)).Value = toIndex
Next
'�ø�ʽˢ�����������ˢ��ԭ���ĸ�ʽ
QuestionSheet.[A2].Copy
QuestionSheet.Range("A2", "A" & CStr(newSpan + 2)).PasteSpecial Paste:=xlPasteFormats, Operation:=xlNone, _
SkipBlanks:=False, Transpose:=False

Rem QuestionSheet���ѭ����ʼ
Rem QuestionSheet���ѭ����ʼ
Rem QuestionSheet���ѭ����ʼ
For iInQuestionSheet = 1 To (newSpan + 1)
toSheetNum = Val(numNewStart) + iInQuestionSheet - 1
lenOftoSheetNum = Len(CStr(toSheetNum))
If lenOftoSheetNum = 1 Then
    toNum = "00" & CStr(toSheetNum)
    toIndex = factory & "-" & toNum
ElseIf lenOftoSheetNum = 2 Then
    toNum = "0" & CStr(toSheetNum)
    toIndex = factory & "-" & toNum
Else
    toNum = CStr(toSheetNum)
    toIndex = factory & "-" & toNum
End If

'������ɫ
'������������
QuestionSheet.Range("B" & CStr(iInQuestionSheet + 1)).Value = Worksheets(toIndex).Range("C3").Value
'����������ɫ
QuestionSheet.Range("B" & CStr(iInQuestionSheet + 1)).Font.Color = Worksheets(toIndex).Range("C3").Interior.Color

Rem �����¼����ͺ��������

'midStart = WorksheetFunction.IfError(WorksheetFunction.Find("��", Worksheets(toIndex).Range("A5")), WorksheetFunction.Find(":", Worksheets(toIndex).Range("A5")))
midStart = InStr(Worksheets(toIndex).Range("A5"), ":")
If midStart = 0 Then midStart = InStr(Worksheets(toIndex).Range("A5"), "��")

If midStart <> 0 Then GoTo noError '����ɹ���⵽ð�ţ�����������һ��δ��������

Rem ��ʼ����������Ĵ��������
Rem ��ʼ����������Ĵ��������
If midStart = 0 Then
MsgBox ("û����" & toIndex & "�����������е�������������ҵ�ð��->��<-������ȷ���������Զ����Խ�����������ı����Ÿ���Ϊð��" _
& "����������Ļ���Ӣ��ð��")

flag = 0

'�ܶ��Сif��Ԫ��ʼ
    If midStart = 0 Then
        midStart = InStr(Worksheets(toIndex).Range("A5"), ",")
        flag = 1
    End If
    If midStart = 0 Then
        midStart = InStr(Worksheets(toIndex).Range("A5"), "��")
        flag = 2
    End If
    If midStart = 0 Then
        midStart = InStr(Worksheets(toIndex).Range("A5"), ".")
        flag = 3
    End If
    If midStart = 0 Then
        midStart = InStr(Worksheets(toIndex).Range("A5"), "��")
        flag = 4
    End If
    If midStart = 0 Then
        midStart = InStr(Worksheets(toIndex).Range("A5"), ";")
        flag = 5
    End If
    If midStart = 0 Then
        midStart = InStr(Worksheets(toIndex).Range("A5"), "��")
        flag = 6
    End If
    If midStart = 0 Then
        midStart = InStr(Worksheets(toIndex).Range("A5"), "'")
        flag = 7
    End If
    If midStart = 0 Then
        midStart = InStr(Worksheets(toIndex).Range("A5"), "��")
        flag = 8
    End If
    If midStart = 0 Then
        midStart = InStr(Worksheets(toIndex).Range("A5"), "��")
        flag = 9
    End If
    If midStart = 0 Then
        midStart = InStr(Worksheets(toIndex).Range("A5"), Chr(34))
        flag = 10
    End If
    If midStart = 0 Then
        midStart = InStr(Worksheets(toIndex).Range("A5"), "<")
        flag = 11
    End If
    If midStart = 0 Then
        midStart = InStr(Worksheets(toIndex).Range("A5"), "��")
        flag = 12
    End If
    If midStart = 0 Then
        midStart = InStr(Worksheets(toIndex).Range("A5"), ">")
        flag = 13
    End If
    If midStart = 0 Then
        midStart = InStr(Worksheets(toIndex).Range("A5"), "��")
        flag = 14
    End If
    If midStart = 0 Then
        midStart = InStr(Worksheets(toIndex).Range("A5"), "?")
        flag = 15
    End If
    If midStart = 0 Then
        midStart = InStr(Worksheets(toIndex).Range("A5"), "��")
        flag = 16
    End If
    If midStart = 0 Then
        midStart = InStr(Worksheets(toIndex).Range("A5"), "|")
        flag = 17
    End If
    If midStart = 0 Then
        midStart = InStr(Worksheets(toIndex).Range("A5"), "[")
        flag = 18
    End If
    If midStart = 0 Then
        midStart = InStr(Worksheets(toIndex).Range("A5"), "��")
        flag = 19
    End If
    If midStart = 0 Then
        midStart = InStr(Worksheets(toIndex).Range("A5"), "]")
        flag = 20
    End If
    If midStart = 0 Then
        midStart = InStr(Worksheets(toIndex).Range("A5"), "��")
        flag = 21
    End If
    If midStart = 0 Then
        midStart = InStr(Worksheets(toIndex).Range("A5"), "��")
        flag = 22
    End If
    If midStart = 0 Then
        midStart = InStr(Worksheets(toIndex).Range("A5"), "/")
        flag = 23
    End If
    If midStart = 0 Then
        midStart = InStr(Worksheets(toIndex).Range("A5"), "\")
        flag = 24
    End If
    If midStart = 0 Then
        midStart = InStr(Worksheets(toIndex).Range("A5"), "��")
        flag = 25
    End If
    If midStart = 0 Then
        midStart = InStr(Worksheets(toIndex).Range("A5"), "��")
        flag = 25
    End If
'�ܶ��Сif��Ԫ����

End If

If midStart = 0 Then
        MsgBox ("�ǳ���Ǹ���ڸ���������" & toIndex & "�������������û��ƥ�䵽���п���������ı����ţ�" _
        & ",��.��;��'��'��<��>��" & "?" & "��|[��]����/\��" & Chr(34) _
        & "���ȷ����������������ֱ��������Ļ���Ӣ��ð��")
        
        '�����ڱ����ţ�ֱ�����
        If (Worksheets(toIndex).Range("A5").Value Like "*co*") Or (Worksheets(toIndex).Range("A5").Value Like "*Co*") Then
            enGLetterLocation = InStr(Worksheets(toIndex).Range("A5").Value, "g")
            enLeft = Mid(Worksheets(toIndex).Range("A5").Value, 1, enGLetterLocation)
            enRight = Mid(Worksheets(toIndex).Range("A5").Value, enGLetterLocation + 1)
            Worksheets(toIndex).Range("A5").Value = enLeft & ":" & enRight
            MsgBox "�ڸ���������" & toIndex & "������������ĺ���λ�óɹ������Ӣ��ð�ţ����ȷ���������г�����Ϊ��ɵ�����"
            midStart = InStr(Worksheets(toIndex).Range("A5").Value, ":")
            GoTo noError
        ElseIf (Worksheets(toIndex).Range("A5").Value Like "*Ͷ��*") _
                Or (Worksheets(toIndex).Range("A5").Value Like "*��ѯ*") _
                Or (Worksheets(toIndex).Range("A5").Value Like "*����*") Then
            boolTouSuExist = Worksheets(toIndex).Range("A5").Value Like "*Ͷ��*"
            boolZiXunExist = Worksheets(toIndex).Range("A5").Value Like "*��ѯ*"
            boolXinLiExist = Worksheets(toIndex).Range("A5").Value Like "*����*"
            If boolTouSuExist Then
                zhKeyHanzi = InStr(Worksheets(toIndex).Range("A5").Value, "��")
                zhLeft = Mid(Worksheets(toIndex).Range("A5").Value, 1, zhKeyHanzi)
                zhLeft = Mid(Worksheets(toIndex).Range("A5").Value, zhKeyHanzi + 1)
                Worksheets(toIndex).Range("A5").Value = zhLeft & "��" & zhRight
            ElseIf boolZiXunExist Then
                zhKeyHanzi = InStr(Worksheets(toIndex).Range("A5").Value, "ѯ")
                zhLeft = Mid(Worksheets(toIndex).Range("A5").Value, 1, zhKeyHanzi)
                zhLeft = Mid(Worksheets(toIndex).Range("A5").Value, zhKeyHanzi + 1)
                Worksheets(toIndex).Range("A5").Value = zhLeft & "��" & zhRight
            ElseIf boolXinLiExist Then
                zhKeyHanzi = InStr(Worksheets(toIndex).Range("A5").Value, "��")
                zhLeft = Mid(Worksheets(toIndex).Range("A5").Value, 1, zhKeyHanzi)
                zhLeft = Mid(Worksheets(toIndex).Range("A5").Value, zhKeyHanzi + 1)
                Worksheets(toIndex).Range("A5").Value = zhLeft & "��" & zhRight
            End If
            midStart = InStr(Worksheets(toIndex).Range("A5").Value, "��")
            GoTo noError
        Else
            MsgBox "û����" & toIndex & "��������������(Problem)���ҵ����Ļ���Ӣ�ĵ��¼����ͣ��롾�ر�Excel���򡿣������˹����ļ��У���" _
            & "NAS���������ظ������ϸ��µ��±�ģ�壬�޸�" & toIndex & "������Ĵ����Լ����������������п��ܵĴ����Ժ������µ���ģ�飬����Ҫ���������г���"
        End If
        '������
ElseIf midStart <> 0 Then '�ҵ���������ı����ţ���ע�⿴һ����δ��룬��ǰ��ì��
    errChar = ""
    boolEn = (Worksheets(toIndex).Range("A5").Value Like "*co*") Or (Worksheets(toIndex).Range("A5").Value Like "*Co*")
    If Not (boolEn) Then
        Select Case flag
            Case 1
                Worksheets(toIndex).Range("A5").Value = Replace(Worksheets(toIndex).Range("A5").Value, ",", "��")
                errChar = ","
            Case 2
                Worksheets(toIndex).Range("A5").Value = Replace(Worksheets(toIndex).Range("A5").Value, "��", "��")
                errChar = "��"
            Case 3
                Worksheets(toIndex).Range("A5").Value = Replace(Worksheets(toIndex).Range("A5").Value, ".", "��")
                errChar = "."
            Case 4
                Worksheets(toIndex).Range("A5").Value = Replace(Worksheets(toIndex).Range("A5").Value, "��", "��")
                errChar = "��"
            Case 5
                Worksheets(toIndex).Range("A5").Value = Replace(Worksheets(toIndex).Range("A5").Value, ";", "��")
                errChar = ";"
            Case 6
                Worksheets(toIndex).Range("A5").Value = Replace(Worksheets(toIndex).Range("A5").Value, "��", "��")
                errChar = "��"
            Case 7
                Worksheets(toIndex).Range("A5").Value = Replace(Worksheets(toIndex).Range("A5").Value, "'", "��")
                errChar = "'"
            Case 8
                Worksheets(toIndex).Range("A5").Value = Replace(Worksheets(toIndex).Range("A5").Value, "��", "��")
                errChar = "��"
            Case 9
                Worksheets(toIndex).Range("A5").Value = Replace(Worksheets(toIndex).Range("A5").Value, "��", "��")
                errChar = "��"
            Case 10
                Worksheets(toIndex).Range("A5").Value = Replace(Worksheets(toIndex).Range("A5").Value, Chr(34), "��")
                errChar = Chr(34)
            Case 11
                Worksheets(toIndex).Range("A5").Value = Replace(Worksheets(toIndex).Range("A5").Value, "<", "��")
                errChar = "<"
            Case 12
            Worksheets(toIndex).Range("A5").Value = Replace(Worksheets(toIndex).Range("A5").Value, "��", "��")
                errChar = "��"
            Case 13
                Worksheets(toIndex).Range("A5").Value = Replace(Worksheets(toIndex).Range("A5").Value, ">", "��")
                errChar = ">"
            Case 14
                Worksheets(toIndex).Range("A5").Value = Replace(Worksheets(toIndex).Range("A5").Value, "��", "��")
                errChar = "��"
            Case 15
                Worksheets(toIndex).Range("A5").Value = Replace(Worksheets(toIndex).Range("A5").Value, "?", "��")
                errChar = "?"
            Case 16
                Worksheets(toIndex).Range("A5").Value = Replace(Worksheets(toIndex).Range("A5").Value, "��", "��")
                errChar = "��"
            Case 17
                Worksheets(toIndex).Range("A5").Value = Replace(Worksheets(toIndex).Range("A5").Value, "|", "��")
                errChar = "|"
            Case 18
                Worksheets(toIndex).Range("A5").Value = Replace(Worksheets(toIndex).Range("A5").Value, "[", "��")
                errChar = "["
            Case 19
                Worksheets(toIndex).Range("A5").Value = Replace(Worksheets(toIndex).Range("A5").Value, "��", "��")
                errChar = "��"
            Case 20
                Worksheets(toIndex).Range("A5").Value = Replace(Worksheets(toIndex).Range("A5").Value, "]", "��")
                errChar = "]"
            Case 21
                Worksheets(toIndex).Range("A5").Value = Replace(Worksheets(toIndex).Range("A5").Value, "��", "��")
            errChar = "��"
                Case 22
            Worksheets(toIndex).Range("A5").Value = Replace(Worksheets(toIndex).Range("A5").Value, "��", "��")
                errChar = "��"
            Case 23
                Worksheets(toIndex).Range("A5").Value = Replace(Worksheets(toIndex).Range("A5").Value, "/", "��")
                errChar = "/"
            Case 24
                Worksheets(toIndex).Range("A5").Value = Replace(Worksheets(toIndex).Range("A5").Value, "\", "��")
                errChar = "\"
            Case 25
                Worksheets(toIndex).Range("A5").Value = Replace(Worksheets(toIndex).Range("A5").Value, "��", "��")
                errChar = "��"
            Case 26
                Worksheets(toIndex).Range("A5").Value = Replace(Worksheets(toIndex).Range("A5").Value, "��", "��")
                errChar = "��"
        End Select
    Else
        Select Case flag
            Case 1
                Worksheets(toIndex).Range("A5").Value = Replace(Worksheets(toIndex).Range("A5").Value, ",", ":")
                errChar = ","
            Case 2
                Worksheets(toIndex).Range("A5").Value = Replace(Worksheets(toIndex).Range("A5").Value, "��", ":")
                errChar = "��"
            Case 3
                Worksheets(toIndex).Range("A5").Value = Replace(Worksheets(toIndex).Range("A5").Value, ".", ":")
                errChar = "."
            Case 4
                Worksheets(toIndex).Range("A5").Value = Replace(Worksheets(toIndex).Range("A5").Value, "��", ":")
                errChar = "��"
            Case 5
                Worksheets(toIndex).Range("A5").Value = Replace(Worksheets(toIndex).Range("A5").Value, ";", ":")
                errChar = ";"
            Case 6
                Worksheets(toIndex).Range("A5").Value = Replace(Worksheets(toIndex).Range("A5").Value, "��", ":")
                errChar = "��"
            Case 7
                Worksheets(toIndex).Range("A5").Value = Replace(Worksheets(toIndex).Range("A5").Value, "'", ":")
                errChar = "'"
            Case 8
                Worksheets(toIndex).Range("A5").Value = Replace(Worksheets(toIndex).Range("A5").Value, "��", ":")
                errChar = "��"
            Case 9
                Worksheets(toIndex).Range("A5").Value = Replace(Worksheets(toIndex).Range("A5").Value, "��", ":")
                errChar = "��"
            Case 10
                Worksheets(toIndex).Range("A5").Value = Replace(Worksheets(toIndex).Range("A5").Value, Chr(34), ":")
                errChar = Chr(34)
            Case 11
                Worksheets(toIndex).Range("A5").Value = Replace(Worksheets(toIndex).Range("A5").Value, "<", ":")
                errChar = "<"
            Case 12
            Worksheets(toIndex).Range("A5").Value = Replace(Worksheets(toIndex).Range("A5").Value, "��", ":")
                errChar = "��"
            Case 13
                Worksheets(toIndex).Range("A5").Value = Replace(Worksheets(toIndex).Range("A5").Value, ">", ":")
                errChar = ">"
            Case 14
                Worksheets(toIndex).Range("A5").Value = Replace(Worksheets(toIndex).Range("A5").Value, "��", ":")
                errChar = "��"
            Case 15
                Worksheets(toIndex).Range("A5").Value = Replace(Worksheets(toIndex).Range("A5").Value, "?", ":")
                errChar = "?"
            Case 16
                Worksheets(toIndex).Range("A5").Value = Replace(Worksheets(toIndex).Range("A5").Value, "��", ":")
                errChar = "��"
            Case 17
                Worksheets(toIndex).Range("A5").Value = Replace(Worksheets(toIndex).Range("A5").Value, "|", ":")
                errChar = "|"
            Case 18
                Worksheets(toIndex).Range("A5").Value = Replace(Worksheets(toIndex).Range("A5").Value, "[", ":")
                errChar = "["
            Case 19
                Worksheets(toIndex).Range("A5").Value = Replace(Worksheets(toIndex).Range("A5").Value, "��", ":")
                errChar = "��"
            Case 20
                Worksheets(toIndex).Range("A5").Value = Replace(Worksheets(toIndex).Range("A5").Value, "]", ":")
                errChar = "]"
            Case 21
                Worksheets(toIndex).Range("A5").Value = Replace(Worksheets(toIndex).Range("A5").Value, "��", ":")
            errChar = "��"
                Case 22
            Worksheets(toIndex).Range("A5").Value = Replace(Worksheets(toIndex).Range("A5").Value, "��", ":")
                errChar = "��"
            Case 23
                Worksheets(toIndex).Range("A5").Value = Replace(Worksheets(toIndex).Range("A5").Value, "/", ":")
                errChar = "/"
            Case 24
                Worksheets(toIndex).Range("A5").Value = Replace(Worksheets(toIndex).Range("A5").Value, "\", ":")
                errChar = "\"
            Case 25
                Worksheets(toIndex).Range("A5").Value = Replace(Worksheets(toIndex).Range("A5").Value, "��", ":")
                errChar = "��"
            Case 26
                Worksheets(toIndex).Range("A5").Value = Replace(Worksheets(toIndex).Range("A5").Value, "��", ":")
                errChar = "��"
        End Select
    End If

    maoHao = iif(boolEn, "Ӣ��ð��", "����ð��")
    MsgBox "����ɹ���⵽" & toIndex & "�������е�������ࣨProblem Type��������������" & Chr(34) & errChar & Chr(34) _
    & "���ȷ�������Զ����÷��Ÿ�Ϊ" & maoHao
    Worksheets(toIndex).Range("A5").Value = Replace(Worksheets(toIndex).Range("A5").Value, errChar, "��")
    MsgBox "����ɹ���������������滻���ˣ�" & maoHao & "���ȷ����������Ľ���"
    If boolEn Then
        midStart = InStr(Worksheets(toIndex).Range("A5").Value, ":")
    Else
        midStart = InStr(Worksheets(toIndex).Range("A5").Value, "��")
    End If
    GoTo noError

End If

Rem ��������������Ĵ��������
Rem ��������������Ĵ��������



noError:
QuestionSheet.Range("C" & CStr(iInQuestionSheet + 1)).Value = Trim(Mid(Worksheets(toIndex).Range("A5").Value, 1, midStart - 1)) '�����ѭ����Ҫ������дQuestion Sheet���е�C�е��¼����ͺ�D�е�������࣬�������C��
QuestionSheet.Range("D" & CStr(iInQuestionSheet + 1)).Value = Trim(Mid(Worksheets(toIndex).Range("A5"), midStart + 1, 100)) '�����ѭ����Ҫ������дQuestion Sheet���е�C�е��¼����ͺ�D�е�������࣬�������D��
Next

Rem QuestionSheet���ѭ������
Rem QuestionSheet���ѭ������
Rem QuestionSheet���ѭ������



'��������п��ܳ��ֵĸ�ʽ���⣬��ɫ�н����⣬���⡣
QuestionSheet.[C2].Copy
QuestionSheet.Range("C2", "C" & CStr(newSpan + 2)).PasteSpecial Paste:=xlPasteFormats, Operation:=xlNone, _
SkipBlanks:=False, Transpose:=False

QuestionSheet.[d2].Copy
QuestionSheet.Range("D2", "D" & CStr(newSpan + 2)).PasteSpecial Paste:=xlPasteFormats, Operation:=xlNone, _
SkipBlanks:=False, Transpose:=False

'������ɫ�е�����
If (QuestionSheet.Range("B2").Value Like "*e*") Then
    With QuestionSheet.Range("B2", "B" & CStr(newSpan + 2))
        .Font.Name = "Arial"
        .Font.Size = 11
        .HorizontalAlignment = xlCenter
        .VerticalAlignment = xlCenter
        .WrapText = True
        .Orientation = 0
        .AddIndent = False
        .IndentLevel = 0
        .ShrinkToFit = False
        .ReadingOrder = xlContext
        .MergeCells = False
    End With
Else
    With QuestionSheet.Range("B2", "B" & CStr(newSpan + 2))
        .HorizontalAlignment = xlCenter
        .VerticalAlignment = xlCenter
        .WrapText = True
        .Orientation = 0
        .AddIndent = False
        .IndentLevel = 0
        .ShrinkToFit = False
        .ReadingOrder = xlContext
        .MergeCells = False
        .Font.Name = "����"
        .Font.Size = 10
    End With
End If

Rem ������δ��������Ϊ�������¿���
 QuestionSheet.Range("B2", "B" & CStr(newSpan + 2)).Borders(xlDiagonalDown).LineStyle = xlNone
    QuestionSheet.Range("B2", "B" & CStr(newSpan + 2)).Borders(xlDiagonalUp).LineStyle = xlNone
    With QuestionSheet.Range("B2", "B" & CStr(newSpan + 2)).Borders(xlEdgeLeft)
        .LineStyle = xlContinuous
        .ColorIndex = 0
        .TintAndShade = 0
        .Weight = xlThin
    End With
    With QuestionSheet.Range("B2", "B" & CStr(newSpan + 2)).Borders(xlEdgeTop)
        .LineStyle = xlContinuous
        .ColorIndex = 0
        .TintAndShade = 0
        .Weight = xlThin
    End With
    With QuestionSheet.Range("B2", "B" & CStr(newSpan + 2)).Borders(xlEdgeBottom)
        .LineStyle = xlContinuous
        .ColorIndex = 0
        .TintAndShade = 0
        .Weight = xlThin
    End With
    With QuestionSheet.Range("B2", "B" & CStr(newSpan + 2)).Borders(xlEdgeRight)
        .LineStyle = xlContinuous
        .ColorIndex = 0
        .TintAndShade = 0
        .Weight = xlThin
    End With
    With QuestionSheet.Range("B2", "B" & CStr(newSpan + 2)).Borders(xlInsideVertical)
        .LineStyle = xlContinuous
        .ColorIndex = 0
        .TintAndShade = 0
        .Weight = xlThin
    End With
    With QuestionSheet.Range("B2", "B" & CStr(newSpan + 2)).Borders(xlInsideHorizontal)
        .LineStyle = xlContinuous
        .ColorIndex = 0
        .TintAndShade = 0
        .Weight = xlThin
    End With
Rem ������δ��������Ϊ�������¿���


End Sub

Sub UpdateQuestionSheetInVertical()
Dim newSpan, oldSpan As Integer

newSpan = Val(numNewEnd) - Val(numNewStart)
oldSpan = Val(numOldEnd) - Val(numOldStart)

Rem ���¸��������
If (oldSpan) > (newSpan) Then
        startClearRow = newSpan + 3
        QuestionSheetInVertical.Range(CStr(startClearRow) & ":65536").Clear
End If
QuestionSheet.Range("C1" & ":D" & (newSpan + 2)).Copy QuestionSheetInVertical.Range("A1") '��newSpan+2
End Sub

Sub UpdatePerspectiveView()
    
    'ѡ������͸�ӱ�
    PerspectiveView.PivotTables("����͸�ӱ�1").PivotSelect "", xlDataAndLabel, True
    '��������Դ
    PerspectiveView.PivotTables("����͸�ӱ�1").ChangePivotCache ActiveWorkbook.PivotCaches. _
        Create(SourceType:=xlDatabase, SourceData:= _
        QuestionSheetInVertical.[A1].CurrentRegion, _
        Version:=xlPivotTableVersion10)
    '����ˢ�����ݱ�
    PerspectiveView.PivotTables("����͸�ӱ�1").PivotCache.Refresh
    PerspectiveView.PivotTables("����͸�ӱ�1").PivotCache.Refresh
    'PerspectiveView.Range("A1").Select
End Sub

Sub LocateALLCursorsOnA1()
Dim sht As Worksheet
For Each sht In currentUseWB.Worksheets
sht.Activate
sht.[A1].Select
Next
CaseSheet.Activate
CaseSheet.[A1].Select
End Sub
