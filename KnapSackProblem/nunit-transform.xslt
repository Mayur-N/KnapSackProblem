<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="html" encoding="utf-8" indent="yes"/>

  <!-- 
    Template for formatting the report.
  -->
  <xsl:template match="/">
    <html>
      <head>
        <title><xsl:value-of select="//test-run/@name"/> - Test Report</title>
        <style>
          body { font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif; margin: 20px; background-color: #f9f9f9; }
          h1 { color: #333; }
          table { border-collapse: collapse; width: 100%; box-shadow: 0 2px 4px rgba(0,0,0,0.1); }
          th, td { border: 1px solid #ddd; padding: 12px; text-align: left; }
          th { background-color: #0078d4; color: white; }
          tr:nth-child(even) { background-color: #f2f2f2; }
          
          /* Result Colors */
          .Passed, .passed { color: #107c10; font-weight: bold; }
          .Failed, .failed { color: #d13438; font-weight: bold; }
          .Skipped, .skipped { color: #888; font-weight: bold; }

          /* Summary Box */
          .summary { 
            margin-bottom: 20px; 
            padding: 20px; 
            background-color: #fff; 
            border-radius: 8px; 
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
          }
          .summary-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
            gap: 20px;
          }
          .summary-item { 
            font-size: 1.1em;
            padding: 15px;
            border-radius: 5px;
            background-color: #f8f8f8;
            border: 1px solid #eee;
          }
          .summary-item strong {
            display: block;
            font-size: 1.5em;
            margin-bottom: 5px;
          }

          /* Chart Bar */
          .chart-container {
            margin-top: 20px;
          }
          .chart-bar {
            width: 100%;
            height: 30px;
            background-color: #eee;
            border-radius: 5px;
            overflow: hidden;
            display: flex;
          }
          .chart-bar-pass { background-color: #107c10; }
          .chart-bar-fail { background-color: #d13438; }
          .chart-bar-skip { background-color: #888; }
          
          .metadata { 
            font-size: 0.9em; 
            color: #555; 
            margin-top: 10px;
          }

        </style>
      </head>
      <body>
        <h1><xsl:value-of select="//test-run/@name"/> - Test Report</h1>

        <!-- 
          Define variables for test results.
          These are calculated once and reused.
        -->
        <xsl:variable name="total-tests" select="count(//test-case)"/>
        <xsl:variable name="passed-tests" select="count(//test-case[@result='Passed'])"/>
        <xsl:variable name="failed-tests" select="count(//test-case[@result='Failed'])"/>
        <xsl:variable name="skipped-tests" select="count(//test-case[@result='Skipped'])"/>
        
        <!-- Calculate percentages -->
        <xsl:variable name="pass-percent" select="format-number($passed-tests div $total-tests * 100, '##0.0')"/>
        <xsl:variable name="fail-percent" select="format-number($failed-tests div $total-tests * 100, '##0.0')"/>
        <xsl:variable name="skip-percent" select="format-number($skipped-tests div $total-tests * 100, '##0.0')"/>

        <!-- Summary Section -->
        <div class="summary">
          <div class="summary-grid">
            <div class="summary-item">
              <strong class="passed"><xsl:value-of select="$pass-percent"/>%</strong>
              Pass Rate
            </div>
            <div class="summary-item">
              <strong><xsl:value-of select="$total-tests"/></strong>
              Total Tests
            </div>
            <div class="summary-item">
              <strong class="passed"><xsl:value-of select="$passed-tests"/></strong>
              Passed
            </div>
            <div class="summary-item">
              <strong class="failed"><xsl:value-of select="$failed-tests"/></strong>
              Failed
            </div>
            <div class="summary-item">
              <strong class="skipped"><xsl:value-of select="$skipped-tests"/></strong>
              Skipped
            </div>
          </div>
          
          <!-- New Chart Bar -->
          <div class="chart-container">
            <strong>Visual Summary:</strong>
            <div class="chart-bar">
              <div class="chart-bar-pass" style="width: {$pass-percent}%" title="Passed: {$pass-percent}%"></div>
              <div class="chart-bar-fail" style="width: {$fail-percent}%" title="Failed: {$fail-percent}%"></div>
              <div class="chart-bar-skip" style="width: {$skip-percent}%" title="Skipped: {$skip-percent}%"></div>
            </div>
          </div>
          
          <!-- New Metadata -->
          <div class="metadata">
            <strong>Run Date:</strong>
            <xsl:value-of select="//test-run/@start-time"/>
          </div>
        </div>

        <!-- Test Case Table -->
        <table>
          <tr>
            <th>Test Case</th>
            <th>Result</th>
            <th>Duration (s)</th>
            <th>Message</th>
          </tr>
          <!-- Loop through all test-case elements in the XML -->
          <xsl:for-each select="//test-case">
            <!-- Sort by result (Failed first) -->
            <xsl:sort select="@result" order="descending"/>
            <tr>
              <td>
                <xsl:value-of select="@fullname"/>
              </td>
              <td>
                <!-- Apply class based on result -->
                <xsl:variable name="result" select="@result"/>
                <span class="{$result}">
                  <xsl:value-of select="$result"/>
                </span>
              </td>
              <td>
                <xsl:value-of select="@duration"/>
              </td>
              <td>
                <!-- Show failure message if it exists -->
                <xsl:value-of select="failure/message"/>
                <!-- Show skipped reason if it exists -->
                <xsl:value-of select="reason/message"/>
              </td>
            </tr>
          </xsl:for-each>
        </table>
      </body>
    </html>
  </xsl:template>

</xsl:stylesheet>
