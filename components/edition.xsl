<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:t="http://www.tei-c.org/ns/1.0" exclude-result-prefixes="t">

  <xsl:output encoding="utf-8"/>

  <xsl:key name="elements-by-id" match="*[@xml:id]" use="@xml:id"/>

  <xsl:param name="bible" select="'bible-quotations.xml'"/>

  <xsl:template match="t:teiHeader"/>

  <xsl:template match="t:bibl">
    <span class="bibl">
      <xsl:apply-templates/>
    </span>
  </xsl:template>

  <xsl:template match="t:witness">

    <xsl:value-of select="t:name"/>
    <xsl:text> (</xsl:text><xsl:value-of select="t:origDate"/>
    <xsl:text>)</xsl:text>
    <xsl:text>, </xsl:text><xsl:value-of select="t:locus"/>
    <xsl:if test="@source">
      <xsl:text> (Abschrift von </xsl:text><xsl:value-of select="translate(@source,'#','')"/><xsl:text>)</xsl:text>
    </xsl:if>
  </xsl:template>

  <xsl:template match="t:div[@type = 'translation']">
    <div>

      <xsl:attribute name="id">
        <xsl:text>translation</xsl:text>

        <xsl:if test="@xml:lang">
          <xsl:text>_</xsl:text>
        </xsl:if>

        <xsl:value-of select="@xml:lang"/>
      </xsl:attribute>

      <xsl:attribute name="class">
        <xsl:text>translation lang_</xsl:text>

        <xsl:value-of select="@xml:lang"/>
      </xsl:attribute>

      <xsl:apply-templates/>
    </div>
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

  <xsl:template match="t:div[parent::t:div/@type='praefatio']">
    <xsl:apply-templates/>
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

  <xsl:template match="t:div[@type = 'textpart']">

    <xsl:element name="div">

      <xsl:attribute name="class">
        <xsl:value-of select="@subtype"/>
      </xsl:attribute>

      <xsl:if test="ancestor::t:div[not(@type='transcription')]">
        <span class='number'>

          <xsl:if test="@subtype='book'">
            <xsl:number format="I" value="@n"/>
          </xsl:if>

          <xsl:if test="@subtype='chapter'">
            <xsl:text>ch. </xsl:text><xsl:number value="@n"/>
          </xsl:if>

          <xsl:if test="@subtype='section'">
            <xsl:text>§ </xsl:text><xsl:number value="@n"/>
          </xsl:if>
        </span>
      </xsl:if>

      <xsl:choose>

        <xsl:when test="child::t:l">
          <ol><xsl:apply-templates/></ol>
        </xsl:when>

        <xsl:otherwise>
          <xsl:apply-templates/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:element>
  </xsl:template>

  <xsl:template match="t:l">

    <xsl:element name="li">

      <xsl:attribute name="value"><xsl:value-of select="@n"/></xsl:attribute>

      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="t:lg">

    <xsl:element name="ol">
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

            <xsl:value-of select="translate(@edRef,'#','')"/>
            <xsl:text>: </xsl:text>
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
    <xsl:value-of select="."/>
  </xsl:template>

  <xsl:template match="t:p">
    <p>
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
      <xsl:text>(</xsl:text><xsl:value-of select="."/>
      <xsl:text>)</xsl:text>
    </span>
  </xsl:template>

  <xsl:template match="t:abbr">
    <span class="abbr">
      <xsl:text></xsl:text><xsl:value-of select="."/>
      <xsl:text></xsl:text>
    </span>
  </xsl:template>

  <xsl:template match="t:gap">
    <span class="gap">

      <xsl:choose>

        <xsl:when test="@quantity and @unit='character'">
          <xsl:text>[.</xsl:text>

          <xsl:value-of select="string(@quantity)"/>
          <xsl:text>]</xsl:text>
        </xsl:when>

        <xsl:otherwise>
          <xsl:text>[.?]</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </span>
  </xsl:template>

  <xsl:template match="t:head">

    <xsl:choose>

      <xsl:when test="parent::t:div[@type='edition'] or parent::t:div[@type='transcription'] or parent::t:div[@type='translation']">
        <h3 class="head"><xsl:apply-templates/></h3>
      </xsl:when>

      <xsl:otherwise>
        <h4>

          <xsl:attribute name="class">head</xsl:attribute>

          <xsl:value-of select='../@n'/>
          <xsl:text> </xsl:text>

          <xsl:apply-templates/>
        </h4>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="t:sp">
    <section class="speak">

      <xsl:if test="./t:speaker">
        <em><xsl:value-of select="./t:speaker/text()"/></em>
      </xsl:if>

      <xsl:choose>

        <xsl:when test="./t:lg">
          <xsl:apply-templates select="./t:lg"/>
        </xsl:when>

        <xsl:when test="./t:p">
          <xsl:apply-templates select="./t:p"/>
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

      <xsl:attribute name="class">supplied</xsl:attribute>
      <xsl:text>&lt;</xsl:text>

      <xsl:apply-templates/>

      <xsl:text>&gt;</xsl:text>
    </span>
  </xsl:template>

  <xsl:template match="t:hi">

    <xsl:if test="@rend='initial'">
      <span>

        <xsl:attribute name="class">initial</xsl:attribute>

        <xsl:value-of select="."/>
      </span>
    </xsl:if>

    <xsl:if test="@rend='overline'">
      <span>

        <xsl:attribute name="class">overline</xsl:attribute>

        <xsl:value-of select="."/>
      </span>
    </xsl:if>
  </xsl:template>

  <xsl:template match="t:expan">
    <xsl:text>(</xsl:text>

    <xsl:value-of select="."/>
    <xsl:text>)</xsl:text>
  </xsl:template>

  <xsl:template match="t:abbr[@type='nomSac']"></xsl:template>

  <xsl:template match="t:choice">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="t:unclear">
    <span>

      <xsl:attribute name="class">unclear</xsl:attribute>

      <xsl:apply-templates/>
    </span>
  </xsl:template>

  <xsl:template match="t:del">

    <xsl:if test="@rend='erasure'">
      <span>

        <xsl:attribute name="class">erased</xsl:attribute>

        <xsl:apply-templates/>
      </span>
    </xsl:if>

    <xsl:if test="@rend='strikethrough'">
      <span>

        <xsl:attribute name="class">strikethrough</xsl:attribute>

        <xsl:apply-templates/>
      </span>
    </xsl:if>

    <xsl:if test="@rend='overwrite'">
      <span>

        <xsl:attribute name="class">strikethrough</xsl:attribute>

        <xsl:apply-templates/>
      </span>
    </xsl:if>
  </xsl:template>

  <xsl:template match="t:add">
    <span>

      <xsl:attribute name="class">added</xsl:attribute>
      <xsl:text>&lt;</xsl:text>

      <xsl:apply-templates/>
      <xsl:text>&gt;</xsl:text>
    </span>
  </xsl:template>

  <xsl:template match="t:note">

    <xsl:if test="ancestor::t:div[@type='praefatio']">
      <a class="footnote" href="#note">
        <i class="fas fas-comment"></i>
      </a>
      <span class="footnoteText">
        <xsl:apply-templates/>
      </span>
    </xsl:if>
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

        <xsl:otherwise></xsl:otherwise>
      </xsl:choose>
    </span>
    <xsl:text> </xsl:text>
  </xsl:template>

  <xsl:template match="t:app[@type='textcritical']">
    <span class="note">

      <xsl:choose>

        <xsl:when test="t:lem=''">
          <xsl:text>*</xsl:text>
          <span class="notetext"><xsl:value-of select="./t:rdg|./t:rdgGrp/t:rdg"/>
            <xsl:text> </xsl:text><xsl:value-of select="translate(./t:rdg/@resp|./t:rdg/@wit|./t:rdg/@source|./t:rdgGrp/t:rdg/@wit,'#','')"/></span>
        </xsl:when>

        <xsl:otherwise>

          <xsl:value-of select="./t:lem"/>
          <span class="notetext"><xsl:value-of select="./t:lem"/>
            <xsl:text> </xsl:text><xsl:value-of select="translate(./t:lem/@resp|./t:lem/@wit|./t:lem/@source,'#','')"/>

            <xsl:choose>

              <xsl:when test="./t:rdg/@cause='omission'">
                <xsl:text> > </xsl:text><xsl:value-of select="translate(./t:rdg/@resp|./t:rdg/@wit|./t:rdg/@source,'#','')"/>
              </xsl:when>

              <xsl:when test="./t:rdg/@cause='addition'">
                <xsl:text> + </xsl:text><xsl:value-of select="./t:rdg"/>
                <xsl:text> </xsl:text><xsl:value-of select="translate(./t:rdg/@resp|./t:rdg/@wit|./t:rdg/@source,'#','')"/>
              </xsl:when>

              <xsl:otherwise>
                <xsl:text> : </xsl:text><xsl:value-of select="t:rdgGrp/t:rdg"/>
                <xsl:text> </xsl:text><xsl:value-of select="translate(./t:rdg/@resp|./t:rdg/@wit|./t:rdg/@source|./t:rdgGrp/t:rdg/@wit,'#','')"/>
              </xsl:otherwise>
            </xsl:choose>
          </span>
        </xsl:otherwise>
      </xsl:choose>
    </span>
  </xsl:template>

  <xsl:template match="t:ref[not(parent::t:seg)]">

    <xsl:if test="@target">

      <xsl:choose>

        <xsl:when test="substring(@target,1,1)='#'">

          <xsl:variable name="idref" select="substring-after(@target,'#')"/>

          <xsl:variable name="referred" select="key('elements-by-id',$idref)"/>

          <xsl:choose>

            <xsl:when test="parent::t:note">

              <xsl:apply-templates/>
              <xsl:text> [</xsl:text>

              <xsl:choose>

                <xsl:when test="$referred[@facs]">
                  <a class="urn">

                    <xsl:attribute name="href">
                      <xsl:value-of select="$referred/@facs"/>
                    </xsl:attribute>

                    <xsl:attribute name="target">
                      _blank
                    </xsl:attribute>

                    <xsl:apply-templates select="$referred"/>
                  </a>
                </xsl:when>

                <xsl:otherwise>
                  <xsl:apply-templates select="$referred"/>
                </xsl:otherwise>
              </xsl:choose>
              <xsl:text>] </xsl:text>
            </xsl:when>

            <xsl:otherwise>
              <a class="footnote" href="#note">
                <xsl:apply-templates/>
              </a>
              <span class="footnoteText">

                <xsl:choose>

                  <xsl:when test="$referred[@facs]">
                    <a class="urn">

                      <xsl:attribute name="href">
                        <xsl:value-of select="$referred/@facs"/>
                      </xsl:attribute>

                      <xsl:attribute name="target">
                        _blank
                      </xsl:attribute>

                      <xsl:apply-templates select="$referred"/>
                    </a>
                  </xsl:when>

                  <xsl:otherwise>
                    <xsl:apply-templates select="$referred"/>
                  </xsl:otherwise>
                </xsl:choose>
              </span>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>

        <xsl:otherwise>
          <a class="urn">

            <xsl:attribute name="href">
              <xsl:value-of select="@target"/>
            </xsl:attribute>

            <xsl:attribute name="target">
              _blank
            </xsl:attribute>

            <xsl:apply-templates/>
          </a>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>

    <xsl:if test="@decls='#biblical'">
      <!-- biblical quotes -->

      <xsl:apply-templates/>
      <xsl:text> </xsl:text>
      <span class="quoteref">

        <xsl:value-of select="concat(substring-before(substring-after(@cRef,':'),':'),' ',translate(substring-after(substring-after(@cRef,':'),':'),':',','))"/>:

        <xsl:value-of select="document($bible)/references/reference[@loc=current()/@cRef]"/>

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

    <xsl:if test="@cRef">
      <!-- biblical quotes -->
      <xsl:text> </xsl:text>
      <span class="ref">

        <xsl:value-of select="concat(substring-before(substring-after(@cRef,':'),':'),' ',translate(substring-after(substring-after(@cRef,':'),':'),':',','))"/>:

        <xsl:value-of select="document($bible)/references/reference[@loc=current()/@cRef]"/>

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

      <xsl:when test="(@type='allusion')">
        <!-- Anspielung-->
        <span class="allusion">
          <xsl:apply-templates/>
        </span>
      </xsl:when>

      <xsl:when test="(@type='insertion')">
        <!-- Einschub in Zitat-->
        <span class="insertion">
          «

          <xsl:apply-templates/>
          »
        </span>
      </xsl:when>

      <xsl:when test="(@type='fq')">
        <!--false quote-->
        <xsl:text> ›</xsl:text>

        <xsl:apply-templates/>
        <xsl:text>‹ </xsl:text>
      </xsl:when>

      <xsl:when test="(@type='psq')">
        <!-- pseudo-quote-->
        <xsl:text> ›</xsl:text>

        <xsl:apply-templates/>
        <xsl:text>‹ </xsl:text>
      </xsl:when>

      <xsl:when test="(@type='corrupt')">
        <!-- korrupter Text-->
        <xsl:text> †</xsl:text>

        <xsl:apply-templates/>
        <xsl:text>† </xsl:text>
      </xsl:when>

      <xsl:when test="(@type='reused')">
        <!-- Intertextualität reused-->
        <xsl:text> </xsl:text>

        <xsl:apply-templates/>
        <xsl:text> </xsl:text>
      </xsl:when>

      <xsl:when test="(@type='reuse')">
        <!-- Intertextualität reuse-->
        <xsl:text> </xsl:text>

        <xsl:apply-templates/>
        <xsl:text> </xsl:text>
      </xsl:when>

      <xsl:when test="@n">
        <!-- subsection type segmentation-->
        <xsl:text> </xsl:text>

        <xsl:value-of select="@n"/>
        <xsl:text> </xsl:text><xsl:apply-templates/>
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
    <span class="unclear"><xsl:value-of select="."/></span>
  </xsl:template>

  <xsl:template match="t:persName">
    <span class="person">
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
