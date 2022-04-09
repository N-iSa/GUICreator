# Load external assemblies
[void][Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
[void][Reflection.Assembly]::LoadWithPartialName("System.Drawing")

#region
$objAusgewaehlt = $null
$bMouseDown = $false
#endregion

#region GUI
#region MenuStrip
# Menu Strip - msTopMenu
$menuStrip = New-Object System.Windows.Forms.MenuStrip
$menuStrip.Dock = [System.Windows.Forms.DockStyle]::Top
# Menu-Items: Datei, Save, Load, Export as (Java, C#, C++, Powershell, Python)
$dateiToolStripMenuItem = New-Object System.Windows.Forms.ToolStripMenuItem
$dateiToolStripMenuItem.Text = "Datei"

# Save as XML? Json? Question for Later
$saveToolStripMenuItem = New-Object System.Windows.Forms.ToolStripMenuItem
$saveToolStripMenuItem.Text = "Save"

$loadToolStripMenuItem = New-Object System.Windows.Forms.ToolStripMenuItem
$loadToolStripMenuItem.Text = "Load"

$exportAsToolStripMenuItem = New-Object System.Windows.Forms.ToolStripMenuItem
$exportAsToolStripMenuItem.Text = "Export as"
$powershellToolStripMenuItem = New-Object System.Windows.Forms.ToolStripMenuItem
$powershellToolStripMenuItem.Text = "Powershell"
#endregion

#region GUI Elements
# Groupbox for GUIElements (Left) - grpGUIElements
$grpGUIElements = New-Object System.Windows.Forms.GroupBox
$grpGUIElements.Text = "GUI Elements"
$grpGUIElements.Dock = [System.Windows.Forms.DockStyle]::Left
$grpGUIElements.Width = 200

<#
$btnAddGUIElement = New-Object System.Windows.Forms.Button
btnAddGUIElement.Text = ""
btnAddGUIElement.Dock = [System.Windows.Forms.Dockstyle]::Top
#>

$btnAddGUIElementButton = New-Object System.Windows.Forms.Button
$btnAddGUIElementButton.Text = "Add Button"
$btnAddGUIElementButton.Dock = [System.Windows.Forms.Dockstyle]::Top

$btnAddGUIElementTextbox = New-Object System.Windows.Forms.Button
$btnAddGUIElementTextbox.Text = "Add Textbox"
$btnAddGUIElementTextbox.Dock = [System.Windows.Forms.Dockstyle]::Top


$btnAddGUIElementListbox = New-Object System.Windows.Forms.Button
$btnAddGUIElementListbox.Text = "Add Listbox"
$btnAddGUIElementListbox.Dock = [System.Windows.Forms.Dockstyle]::Top

$btnAddGUIElementCombobox = New-Object System.Windows.Forms.Button
$btnAddGUIElementCombobox.Text = "Add Combobox"
$btnAddGUIElementCombobox.Dock = [System.Windows.Forms.Dockstyle]::Top

$btnAddGUIElementCheckbox = New-Object System.Windows.Forms.Button
$btnAddGUIElementCheckbox.Text = "Add Checkbox"
$btnAddGUIElementCheckbox.Dock = [System.Windows.Forms.Dockstyle]::Top
#endregion

#region GUI Designer
# Groupbox for GUI - grpGUI (Center)
$grpGUI = New-Object System.Windows.Forms.GroupBox
$grpGUI.Text = "GUI Designer"
$grpGUI.Dock = [System.Windows.Forms.DockStyle]::Fill

# Base Form-Element for Design
$frmDesign = New-Object System.Windows.Forms.Form
$frmDesign.TopLevel = $false
$frmDesign.Visible = $true
$frmDesign.Location = New-Object System.Drawing.Size(10, 20)
#endregion

#region GUI Settings
# Groupbox for GUIElementSettings - grpGUIElementSettings
$grpGUIElementSettings = New-Object System.Windows.Forms.GroupBox
$grpGUIElementSettings.Text = "GUI Settings"
$grpGUIElementSettings.Dock = [System.Windows.Forms.DockStyle]::Right
$grpGUIElementSettings.Width = 400
#endregion


# Mainform
$frmHauptfenster = New-Object System.Windows.Forms.Form
$frmHauptfenster.WindowState = "Maximized"


#region Add Controls to Parent-Control
$menuStrip.Items.Add($dateiToolStripMenuItem)
$dateiToolStripMenuItem.DropDownItems.Add($saveToolStripMenuItem)
$dateiToolStripMenuItem.DropDownItems.Add($loadToolStripMenuItem)
$dateiToolStripMenuItem.DropDownItems.Add($exportAsToolStripMenuItem)
$exportAsToolStripMenuItem.DropDownItems.Add($powershellToolStripMenuItem)

$frmHauptfenster.Controls.Add($grpGUI)
$frmHauptfenster.Controls.Add($grpGUIElements)
$frmHauptfenster.Controls.Add($grpGUIElementSettings)
$frmHauptfenster.Controls.Add($menuStrip)

$grpGUI.Controls.Add($frmDesign)

$grpGUIElements.Controls.Add($btnAddGUIElementCheckbox)
$grpGUIElements.Controls.Add($btnAddGUIElementCombobox)
$grpGUIElements.Controls.Add($btnAddGUIElementListbox)
$grpGUIElements.Controls.Add($btnAddGUIElementTextbox)
$grpGUIElements.Controls.Add($btnAddGUIElementButton)
#endregion
#endregion

#region Events and Functions
# Function
function UpdateControlValues()
{
}

function addNewControl()
{
    param(
        [Type] $type
    )
    $obj = New-Object $type
    
    $obj.Add_MouseDown({
        param($sender, $e)
        if($e.Button -eq ([System.Windows.Forms.MouseButtons]::Right))
        {
            $frmDesign.Controls.Remove($sender)
            $sender.Dispose()
        }
        else
        {
            $Script:objAusgewaehlt = $sender
            $Script:bMouseDown = $true
        }
    })
    $obj.Add_MouseUp({
        $Script:bMouseDown = $false
    })

    $obj.Add_MouseMove({
        param($sender, $e)
        if($bMouseDown)
        {
            $point = $frmDesign.PointToClient([System.Windows.Forms.Cursor]::Position)
            $sender.Location = New-Object System.Drawing.Size(($point.X - ($sender.Width / 2)), ($point.Y - ($sender.Height / 2)))
        }
    })

    $frmDesign.Controls.Add($obj)
}

# Add Events to Controls
$btnAddGUIElementButton.Add_Click({
    addNewControl System.Windows.Forms.Button
})
$btnAddGUIElementTextbox.Add_Click({
    addNewControl System.Windows.Forms.Textbox
})
$btnAddGUIElementListbox.Add_Click({
    addNewControl System.Windows.Forms.Listbox
})
$btnAddGUIElementCombobox.Add_Click({
    addNewControl System.Windows.Forms.Combobox
})
$btnAddGUIElementCheckbox.Add_Click({
    addNewControl System.Windows.Forms.Checkbox
})

$frmDesign.Add_LocationChanged({
    $frmDesign.Location = New-Object System.Drawing.Size(10, 20) 
}) 
#endregion



$frmHauptfenster.ShowDialog()

$frmDesign.Dispose()
$frmHauptfenster.Dispose()