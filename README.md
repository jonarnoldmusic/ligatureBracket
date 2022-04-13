# ligatureBracket
LigatureBracket plugin for MuseScore

When at least one Note Anchored Line is selected, this plugin will add beginning and ending hooks, and move it above the staff to indicate a ligature in mensural notation. The line will be placed place them above the staff either equivalent to two ledger lines above or two staff spaces above the note if it is above the staff already.

Current limitations:
- user must create the Note Anchored Line by selecting a range and navigating through the program menu: Add->Lines->Note Anchored Line
- a line that extends over a system break must have each segment processed (select each part of the line and run the plugin)
- if the line has been processed by the plugin once and the end point is adjusted, running the plugin again will not achieve desired results
