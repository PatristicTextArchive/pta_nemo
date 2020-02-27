<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:t="http://www.tei-c.org/ns/1.0" exclude-result-prefixes="t">
<xsl:output encoding="utf-8"/>
<xsl:param name="bible" select="'bible-quotations.xml'" />
  
    <!-- glyphs -->
    <xsl:template name="split-refs">
        <xsl:param name="pText"/>
        <xsl:if test="string-length($pText)">
            <xsl:if test="not($pText=.)">
                <xsl:text> </xsl:text>
            </xsl:if>
            <xsl:element name="a">
                <xsl:attribute name="href">
                    <xsl:value-of select="concat('http://cts.perseids.org/api/cts/?request=GetPassage', '&#38;', 'urn=', substring-before(concat($pText,','),','))"/>
                </xsl:attribute>
                <xsl:attribute name="target">_blank</xsl:attribute>
                <xsl:value-of select="substring-before(concat($pText,','),',')" />
            </xsl:element>
            <xsl:call-template name="split-refs">
                <xsl:with-param name="pText" select=
                    "substring-after($pText, ',')"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>

 <xsl:template match="t:teiHeader" />
    
    <xsl:template match="t:div[@type = 'translation']">
    <div>
      <xsl:attribute name="id">
        <xsl:text>translation</xsl:text>
        <xsl:if test="@xml:lang"><xsl:text>_</xsl:text></xsl:if>
        <xsl:value-of select="@xml:lang"/>
      </xsl:attribute>
      
      <xsl:attribute name="class">
        <xsl:text>translation lang_</xsl:text>
        <xsl:value-of select="@xml:lang"/>
      </xsl:attribute>
      
      
      <xsl:apply-templates/>
    
    </div>
  </xsl:template>
    
    <xsl:template match="t:w">
        <xsl:element name="span">
            <xsl:attribute name="class">w</xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="t:pc">
        <xsl:element name="span">
            <xsl:attribute name="class">
                <xsl:text>pc_</xsl:text>
                <xsl:value-of select="@unit|@type"/>
            </xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="t:body">
      <div>
	<xsl:apply-templates/>
      </div>
    </xsl:template>

    <xsl:template match="t:div[@type = 'praefatio']">
    <div>
      <xsl:attribute name="class">
        <xsl:text>praefatio lang_</xsl:text>
        <xsl:value-of select="@xml:lang"/>
      </xsl:attribute>
      
      <h3>
      <xsl:attribute name="id">
        <xsl:text>praefatio</xsl:text>
      </xsl:attribute>
      <xsl:text>Praefatio</xsl:text>
      <a>
	<xsl:attribute name="class">
          <xsl:text>btn btn-link</xsl:text>
	</xsl:attribute>
	<xsl:attribute name="data-toggle">
          <xsl:text>collapse</xsl:text>
	</xsl:attribute>
	<xsl:attribute name="href">
          <xsl:text>#collapsePraef</xsl:text>
	</xsl:attribute>
	<xsl:attribute name="role">
          <xsl:text>button</xsl:text>
	</xsl:attribute>
	<xsl:attribute name="aria-exanded">
          <xsl:text>false</xsl:text>
	</xsl:attribute>
	<xsl:attribute name="aria-controls">
          <xsl:text>collapsePraef</xsl:text>
	</xsl:attribute>
	<i>
	  <xsl:attribute name="class">
            <xsl:text>fas fas-angle-double-down</xsl:text>
	  </xsl:attribute>
	</i>
      </a>
      </h3>
      <div class="collapse" id="collapsePraef">
      <xsl:apply-templates/>
      </div>
    </div>
  </xsl:template>
    
    <xsl:template match="t:div[@type = 'edition']">
        <div id="edition">
            <xsl:attribute name="class">
                <xsl:text>edition lang_</xsl:text>
                <xsl:value-of select="@xml:lang"/>
            </xsl:attribute>
            <xsl:attribute name="data-lang"><xsl:value-of select="./@xml:lang"/></xsl:attribute>
            <xsl:if test="@xml:lang = 'heb'">
                <xsl:attribute name="dir">
                    <xsl:text>rtl</xsl:text>
                </xsl:attribute>
            </xsl:if>
            <xsl:apply-templates/>
        </div>
    </xsl:template>

    <xsl:template match="t:head/title">
        <xsl:element name="div">
            <xsl:attribute name="class">
                section
            </xsl:attribute>
                  <span class='number'>0</span>
            <xsl:apply-templates select="@urn" />
            <xsl:if test="./@sameAs">
               <xsl:element name="p">
                   <xsl:element name="small">
                       <xsl:text>Sources </xsl:text>
                       <xsl:choose>
                           <xsl:when test="@cert = 'low'">
                               <xsl:text>(D'après)</xsl:text>
                           </xsl:when>
                       </xsl:choose>
                       <xsl:text> : </xsl:text>
                       <xsl:call-template name="split-refs">
                           <xsl:with-param name="pText" select="./@sameAs"/>
                       </xsl:call-template>
                   </xsl:element>
               </xsl:element>
            </xsl:if>
            <xsl:choose>
                <xsl:when test="child::t:l">
                    <ol><xsl:apply-templates /></ol>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:element>
    </xsl:template>


    <xsl:template match="t:div[@type = 'textpart']">
        <xsl:element name="div">
            <xsl:attribute name="class">
                <xsl:value-of select="@subtype" />
            </xsl:attribute>
            <xsl:if test="ancestor::t:div[not(@type='transcription')]">
	      <span class='number'>
		<xsl:if test="@subtype='book'">
		<xsl:number format="I" value="@n" />
	      </xsl:if>
	      <xsl:if test="@subtype='chapter'">
		<xsl:text>ch. </xsl:text><xsl:number value="@n" />
	      </xsl:if>
	      <xsl:if test="@subtype='section'">
		<xsl:text>§ </xsl:text><xsl:number value="@n" />
	      </xsl:if>
	      </span>
	    </xsl:if>
            <xsl:apply-templates select="@urn" />
            <xsl:if test="./@sameAs">
               <xsl:element name="p">
                   <xsl:element name="small">
                       <xsl:text>Sources </xsl:text>
                       <xsl:choose>
                           <xsl:when test="@cert = 'low'">
                               <xsl:text>(D'après)</xsl:text>
                           </xsl:when>
                       </xsl:choose>
                       <xsl:text> : </xsl:text>
                       <xsl:call-template name="split-refs">
                           <xsl:with-param name="pText" select="./@sameAs"/>
                       </xsl:call-template>
                   </xsl:element>
               </xsl:element>
            </xsl:if>
            <xsl:choose>
                <xsl:when test="child::t:l">
                    <ol><xsl:apply-templates /></ol>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="t:l">
        <xsl:element name="li">
            <xsl:apply-templates select="@urn" />
            <xsl:attribute name="value"><xsl:value-of select="@n"/></xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="t:lg">
        <xsl:element name="ol">
            <xsl:apply-templates select="@urn" />
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="t:pb">
      <span class='pb'>
      <xsl:if test="@edRef">
	<xsl:choose>
	    <xsl:when test="@facs">
	<xsl:element name="a">
          <xsl:attribute name="href">
              <xsl:value-of select="@facs"/>
          </xsl:attribute>
          <xsl:attribute name="target">_blank</xsl:attribute>
          <xsl:value-of select="translate(@edRef,'#',' ')"/>
        </xsl:element>
	<xsl:text>: </xsl:text>
	    </xsl:when>
	    <xsl:otherwise>
          <xsl:value-of select="translate(@edRef,'#','')"/><xsl:text>: </xsl:text>
	    </xsl:otherwise>
	</xsl:choose>
      </xsl:if>
      <xsl:value-of select="@n"/>
      </span>
      <xsl:if test="ancestor::t:div[@type='transcription']"><br/></xsl:if>
    </xsl:template>

    <xsl:template match="t:cb">
      <span class='pb'><xsl:value-of select="@n"/>
      <xsl:if test="@edRef">
                <em><xsl:value-of select="@edRef"/></em>
      </xsl:if>
      </span>
      <xsl:if test="ancestor::t:div[@type='transcription']"><br/></xsl:if>
    </xsl:template>

    <xsl:template match="t:ab/text()">
        <xsl:value-of select="." />
    </xsl:template>
    
    
    <xsl:template match="t:p">
        <p>
            <xsl:apply-templates select="@urn" />
            <xsl:apply-templates/>
        </p>
    </xsl:template>
    
    
    <xsl:template match="t:lb">
      <xsl:if test="@break='no'">
	<span class="lb">-</span>
      </xsl:if>
      <br/>
    </xsl:template>
    
    
    <xsl:template match="t:ex">
        <span class="ex">
            <xsl:text>(</xsl:text><xsl:value-of select="." /><xsl:text>)</xsl:text>
        </span>
    </xsl:template>
    
    <xsl:template match="t:abbr">
        <span class="abbr">
            <xsl:text></xsl:text><xsl:value-of select="." /><xsl:text></xsl:text>
        </span>
    </xsl:template>  
    
    <xsl:template match="t:gap">
        <span class="gap">
            <xsl:choose>
                <xsl:when test="@quantity and @unit='character'">
                    <xsl:value-of select="string(@quantity)" />
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>&lt;...&gt;</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
            
        </span>
    </xsl:template>
    
    <xsl:template match="t:head">
      <xsl:choose>
	<xsl:when test="parent::t:div[@type='edition']">
          <h3 class="head"><xsl:apply-templates />
          <xsl:apply-templates select="@urn" /></h3>
	</xsl:when>
	<xsl:otherwise>
          <h4 class="head"><xsl:apply-templates /></h4>	  
	</xsl:otherwise>
      </xsl:choose>
    </xsl:template>
    
    <xsl:template match="@urn">
        <xsl:attribute name="data-urn"><xsl:value-of select="."/></xsl:attribute>
    </xsl:template>
    
    <xsl:template match="t:sp">
        <section class="speak">
            <xsl:if test="./t:speaker">
                <em><xsl:value-of select="./t:speaker/text()" /></em>
            </xsl:if>
            <xsl:choose>
                <xsl:when test="./t:lg">
                    <xsl:apply-templates select="./t:lg" />
                </xsl:when>
                <xsl:when test="./t:p">
                    <xsl:apply-templates select="./t:p" />
                </xsl:when>
                <xsl:otherwise>
                    <ol>
                        <xsl:apply-templates select="./t:l"/>
                    </ol>
                </xsl:otherwise>
            </xsl:choose>
        </section>
    </xsl:template>
    
    <xsl:template match="t:supplied">
        <span>
            <xsl:attribute name="class">supplied supplied_<xsl:value-of select='@cert' /></xsl:attribute>
            <xsl:text>[</xsl:text>
            <xsl:apply-templates/><xsl:if test="@cert = 'low'"><xsl:text>?</xsl:text></xsl:if>
            <xsl:text>]</xsl:text>
        </span>
    </xsl:template>

    <xsl:template match="t:del">
        <span>
            <xsl:attribute name="class">deleted</xsl:attribute>
            <xsl:text>[</xsl:text>
            <xsl:apply-templates/>
            <xsl:text>]</xsl:text>
        </span>
    </xsl:template>
    
    <xsl:template match="t:note">
      <!-- empty -->
    </xsl:template>

    <xsl:template match="t:app[@type='witnesses']">
      <span class="note">
	<xsl:value-of select="./t:rdg"/>
	<xsl:choose>
	  <xsl:when test=".//t:witStart">
	    <span class="notetext">
	      <xsl:text>inc. </xsl:text><xsl:value-of select="translate(./t:rdg/@resp|./t:rdg/@wit,'#','')"/>
	    </span>
	  </xsl:when>
	  <xsl:when test=".//t:witEnd">
	    <span class="notetext">
	      <xsl:text>des. </xsl:text><xsl:value-of select="translate(./t:rdg/@resp|./t:rdg/@wit,'#','')"/>
	    </span>
	  </xsl:when>
	  <xsl:otherwise>
	  </xsl:otherwise>
	</xsl:choose>
      </span>
      <xsl:text> </xsl:text>
    </xsl:template>
    
    <xsl:template match="t:app[@type='textcritical']">
      <span class="note">
	<xsl:choose>
	  <xsl:when test="t:lem=''">
	    <xsl:text>*</xsl:text><span class="notetext"><xsl:value-of select="./t:rdg"/><xsl:text> </xsl:text><xsl:value-of select="translate(./t:rdg/@resp|./t:rdg/@wit,'#','')"/></span>
	  </xsl:when>
	  <xsl:otherwise>
	    <xsl:value-of select="./t:lem"/><span class="notetext"><xsl:value-of select="./t:lem"/><xsl:text> </xsl:text><xsl:value-of select="translate(./t:lem/@resp|./t:lem/@wit,'#','')"/>
	    <xsl:choose>
	      <xsl:when test="./t:rdg/@cause='omission'">
		<xsl:text> > </xsl:text><xsl:value-of select="translate(./t:rdg/@resp|./t:rdg/@wit,'#','')"/>
	      </xsl:when>
	      <xsl:when test="./t:rdg/@cause='addition'">
		<xsl:text> + </xsl:text><xsl:value-of select="./t:rdg"/><xsl:text> </xsl:text><xsl:value-of select="translate(./t:rdg/@resp|./t:rdg/@wit,'#','')"/>
	      </xsl:when>
	      <xsl:otherwise>
		<xsl:text> : </xsl:text><xsl:value-of select="./t:rdg"/><xsl:text> </xsl:text><xsl:value-of select="translate(./t:rdg/@resp|./t:rdg/@wit,'#','')"/>
	      </xsl:otherwise>
	    </xsl:choose>
	  </span>
	  </xsl:otherwise>
	</xsl:choose>
	</span>
    </xsl:template>
    
    <xsl:template match="t:choice">
        <span class="choice">
            <xsl:attribute name="title">
                <xsl:value-of select="reg" />
            </xsl:attribute>
            <xsl:value-of select="orig" /><xsl:text> </xsl:text>
        </span>
    </xsl:template>

   <xsl:template match="t:ref[not(parent::t:seg)]">
	<xsl:apply-templates/>
      <xsl:if test="@target">
        <a class="urn">
            <xsl:attribute name="href">
                <xsl:value-of select="@target"/>
            </xsl:attribute>
            <xsl:value-of select="." />
            [*]
        </a>
        </xsl:if>
	<xsl:if test="@cRef"> <!-- biblical quotes -->
	  <xsl:text> </xsl:text>
	  <span class="quoteref">
	    <xsl:value-of select="concat(substring-before(substring-after(@cRef,':'),':'),' ',translate(substring-after(substring-after(@cRef,':'),':'),':',','))"/>: <xsl:value-of select="document($bible)/references/reference[@loc=current()/@cRef]"/>
	    <xsl:if test="contains(@cRef, 'NA')">
	      (Text: SBLGNT)
	    </xsl:if>
	    <xsl:if test="contains(@cRef, 'LXX')">
	      (Text: Rahlfs)
	    </xsl:if>
	  </span>
	  <xsl:text> </xsl:text>
	</xsl:if>
   </xsl:template>

      <xsl:template match="t:ref[parent::t:seg]">
	<xsl:apply-templates/>
	<xsl:if test="@cRef"> <!-- biblical quotes -->
	  <xsl:text> </xsl:text>
	  <span class="ref">
	    <xsl:value-of select="concat(substring-before(substring-after(@cRef,':'),':'),' ',translate(substring-after(substring-after(@cRef,':'),':'),':',','))"/>: <xsl:value-of select="document($bible)/references/reference[@loc=current()/@cRef]"/>
	    <xsl:if test="contains(@cRef, 'NA')">
	      (Text: SBLGNT)
	    </xsl:if>
	    <xsl:if test="contains(@cRef, 'LXX')">
	      (Text: Rahlfs)
	    </xsl:if>
	  </span>
	  <xsl:text> </xsl:text>
	</xsl:if>
    </xsl:template>

    <xsl:template match="t:cit">
      <xsl:text> </xsl:text>
      		<span class="quote">
		  <xsl:if test="t:ref[following-sibling::t:quote]">
		    <xsl:apply-templates select="t:ref"/>
		  </xsl:if>
		  »<xsl:apply-templates select="t:quote"/>«
		  <xsl:if test="t:ref[preceding-sibling::t:quote]">
		    <xsl:apply-templates select="t:ref"/>
		  </xsl:if>
		</span>
    </xsl:template>
    
	<xsl:template match="t:quote[t:ref]">
        <span class="quote">
	»<xsl:apply-templates/>«
	</span>
    </xsl:template>

	<xsl:template match="t:seg">
		<xsl:choose>
		  <xsl:when test="(@type='allusion')"> <!-- Anspielung-->
		    <span class="allusion">
		      <xsl:apply-templates/>
		    </span>
			</xsl:when>
			<xsl:when test="(@type='insertion')"> <!-- Einschub in Zitat-->
				<span class="insertion">
				« <xsl:apply-templates/> »
				</span>
			</xsl:when>
			<xsl:when test="(@type='fq')"> <!--false quote-->
				<xsl:text> ›</xsl:text>
				<xsl:apply-templates/>
				<xsl:text>‹ </xsl:text>
			</xsl:when>
			<xsl:when test="(@type='psq')"> <!-- pseudo-quote-->
				<xsl:text> ›</xsl:text>
				<xsl:apply-templates/>
				<xsl:text>‹ </xsl:text>
			</xsl:when>
			<xsl:when test="(@type='corrupt')"> <!-- korrupter Text-->
				<xsl:text> †</xsl:text>
				<xsl:apply-templates/>
				<xsl:text>† </xsl:text>
			</xsl:when>
			<xsl:when test="(@type='reused')"> <!-- Intertextualität reused-->
				<xsl:text> </xsl:text>
				<xsl:apply-templates/>
				<xsl:text> </xsl:text>
			</xsl:when>
			<xsl:when test="(@type='reuse')"> <!-- Intertextualität reuse-->
				<xsl:text> </xsl:text>
				<xsl:apply-templates/>
				<xsl:text> </xsl:text>
			</xsl:when>
			<xsl:when test="@n"> <!-- subsection type segmentation-->
				<xsl:text> </xsl:text>
				<xsl:value-of select="@n"/><xsl:text> </xsl:text><xsl:apply-templates/>
				<xsl:text> </xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text> </xsl:text>
				<xsl:apply-templates/>
				<xsl:text> </xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="t:mentioned">
		<xsl:text> ›</xsl:text>
		<xsl:apply-templates/>
		<xsl:text>‹  </xsl:text>
	</xsl:template>

	<xsl:template match="t:said">
		<xsl:text> »</xsl:text>
		<xsl:apply-templates/>
		<xsl:text>« </xsl:text>
	      </xsl:template>


   <xsl:template match="t:unclear">
        <span class="unclear"><xsl:value-of select="." /></span>
    </xsl:template>
    
    <xsl:template match="t:persName">
        <span class="person">
	<xsl:apply-templates/>
	</span>
    </xsl:template>

    <xsl:template match="t:placeName">
        <span class="place">
        <a class="urn">
            <xsl:attribute name="href">
                <xsl:value-of select="@ref"/>
            </xsl:attribute>
	    <xsl:attribute name="target">
	      _blank
	    </xsl:attribute>
            <xsl:apply-templates/>
        </a>
	</span>
    </xsl:template>

</xsl:stylesheet>
