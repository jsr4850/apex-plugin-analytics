set define off verify off feedback off
whenever sqlerror exit sql.sqlcode rollback
--------------------------------------------------------------------------------
--
-- ORACLE Application Express (APEX) export file
--
-- You should run the script connected to SQL*Plus as the Oracle user
-- APEX_180200 or as the owner (parsing schema) of the application.
--
-- NOTE: Calls to apex_application_install override the defaults below.
--
--------------------------------------------------------------------------------
begin
wwv_flow_api.import_begin (
 p_version_yyyy_mm_dd=>'2018.05.24'
,p_release=>'18.2.0.00.12'
,p_default_workspace_id=>1590165121497720
,p_default_application_id=>280
,p_default_owner=>'APEX_ANALYTICS'
);
end;
/
 
prompt APPLICATION 280 - APEX Analytics
--
-- Application Export:
--   Application:     280
--   Name:            APEX Analytics
--   Date and Time:   16:13 Tuesday January 29, 2019
--   Exported By:     APEX_ANALYTICS
--   Flashback:       0
--   Export Type:     Application Export
--   Version:         18.2.0.00.12
--   Instance ID:     218241076071283
--

-- Application Statistics:
--   Pages:                     20
--     Items:                   81
--     Validations:              7
--     Processes:               23
--     Regions:                 74
--     Buttons:                 36
--     Dynamic Actions:         29
--   Shared Components:
--     Logic:
--       App Settings:           8
--       Build Options:          1
--       Data Loading:           2
--     Navigation:
--       Lists:                  5
--       Breadcrumbs:            1
--         Entries:              3
--     Security:
--       Authentication:         1
--       Authorization:          2
--     User Interface:
--       Themes:                 1
--       Templates:
--         Page:                 9
--         Region:              15
--         Label:                7
--         List:                12
--         Popup LOV:            1
--         Calendar:             1
--         Breadcrumb:           1
--         Button:               3
--         Report:              10
--       LOVs:                   4
--       Shortcuts:              1
--       Plug-ins:               4
--     Globalization:
--     Reports:
--     E-Mail:
--   Supporting Objects:  Excluded

prompt --application/shared_components/plugins/dynamic_action/de_danielh_apexanalytics
begin
wwv_flow_api.create_plugin(
 p_id=>wwv_flow_api.id(6269942285913443)
,p_plugin_type=>'DYNAMIC ACTION'
,p_name=>'DE.DANIELH.APEXANALYTICS'
,p_display_name=>'APEX Analytics'
,p_category=>'INIT'
,p_supported_ui_types=>'DESKTOP'
,p_image_prefix => nvl(wwv_flow_application_install.get_static_plugin_file_prefix('DYNAMIC ACTION','DE.DANIELH.APEXANALYTICS'),'')
,p_javascript_file_urls=>wwv_flow_string.join(wwv_flow_t_varchar2(
'#PLUGIN_FILES#js/uap#MIN#.js',
'#PLUGIN_FILES#js/apexanalytics#MIN#.js'))
,p_plsql_code=>wwv_flow_string.join(wwv_flow_t_varchar2(
'--',
'-- Plug-in Render Function',
'-- #param p_dynamic_action',
'-- #param p_plugin',
'-- #return apex_plugin.t_dynamic_action_render_result',
'FUNCTION render_apexanalytics(p_dynamic_action IN apex_plugin.t_dynamic_action,',
'                              p_plugin         IN apex_plugin.t_plugin)',
'  RETURN apex_plugin.t_dynamic_action_render_result IS',
'  --',
'  l_result apex_plugin.t_dynamic_action_render_result;',
'  --',
'  -- plugin attributes',
'  l_analytics_rest_url p_plugin.attribute_01%TYPE := p_plugin.attribute_01;',
'  --',
'  l_additional_info_item   p_dynamic_action.attribute_01%TYPE := p_dynamic_action.attribute_01;',
'  l_encode_webservice_call VARCHAR2(5) := nvl(p_dynamic_action.attribute_02,',
'                                              ''N'');',
'  l_stop_on_max_error      NUMBER := nvl(p_dynamic_action.attribute_03,',
'                                         3);',
'  l_respect_donottrack     VARCHAR2(5) := nvl(p_dynamic_action.attribute_04,',
'                                              ''N'');',
'  --',
'  -- other vars',
'  l_analytics_id_string   VARCHAR2(500);',
'  l_analytics_id          VARCHAR2(128);',
'  l_component_config_json CLOB := empty_clob();',
'  --',
'  -- SHA256 Hash (from OOS_UTILS: https://github.com/OraOpenSource/oos-utils/blob/master/source/packages/oos_util_crypto.pkb)',
'  FUNCTION sha256(p_msg IN VARCHAR2) RETURN RAW IS',
'    --',
'    bmax32 CONSTANT NUMBER := power(2,',
'                                    32) - 1;',
'    bmax64 CONSTANT NUMBER := power(2,',
'                                    64) - 1;',
'    --',
'    l_msg       RAW(32767);',
'    t_md        VARCHAR2(128);',
'    fmt1        VARCHAR2(10) := ''xxxxxxxx'';',
'    fmt2        VARCHAR2(10) := ''fm0xxxxxxx'';',
'    t_len       PLS_INTEGER;',
'    t_pad_len   PLS_INTEGER;',
'    t_pad       VARCHAR2(144);',
'    t_msg_buf   VARCHAR2(32766);',
'    t_idx       PLS_INTEGER;',
'    t_chunksize PLS_INTEGER := 16320; -- 255 * 64',
'    t_block     VARCHAR2(128);',
'    TYPE tp_tab IS TABLE OF NUMBER;',
'    ht    tp_tab;',
'    k     tp_tab;',
'    w     tp_tab;',
'    h_str VARCHAR2(64);',
'    k_str VARCHAR2(512);',
'    a     NUMBER;',
'    b     NUMBER;',
'    c     NUMBER;',
'    d     NUMBER;',
'    e     NUMBER;',
'    f     NUMBER;',
'    g     NUMBER;',
'    h     NUMBER;',
'    s0    NUMBER;',
'    s1    NUMBER;',
'    maj   NUMBER;',
'    ch    NUMBER;',
'    t1    NUMBER;',
'    t2    NUMBER;',
'    tmp   NUMBER;',
'    --',
'    FUNCTION bitor(x NUMBER,',
'                   y NUMBER) RETURN NUMBER IS',
'    BEGIN',
'      RETURN x + y - bitand(x,',
'                            y);',
'    END;',
'    --',
'    FUNCTION bitxor(x NUMBER,',
'                    y NUMBER) RETURN NUMBER IS',
'    BEGIN',
'      RETURN x + y - 2 * bitand(x,',
'                                y);',
'    END;',
'    --',
'    FUNCTION shl(x NUMBER,',
'                 b PLS_INTEGER) RETURN NUMBER IS',
'    BEGIN',
'      RETURN x * power(2,',
'                       b);',
'    END;',
'    --',
'    FUNCTION shr(x NUMBER,',
'                 b PLS_INTEGER) RETURN NUMBER IS',
'    BEGIN',
'      RETURN trunc(x / power(2,',
'                             b));',
'    END;',
'    --',
'    FUNCTION bitor32(x INTEGER,',
'                     y INTEGER) RETURN INTEGER IS',
'    BEGIN',
'      RETURN bitand(x + y - bitand(x,',
'                                   y),',
'                    bmax32);',
'    END;',
'    --',
'    FUNCTION bitxor32(x INTEGER,',
'                      y INTEGER) RETURN INTEGER IS',
'    BEGIN',
'      RETURN bitand(x + y - 2 * bitand(x,',
'                                       y),',
'                    bmax32);',
'    END;',
'    --',
'    FUNCTION ror32(x NUMBER,',
'                   b PLS_INTEGER) RETURN NUMBER IS',
'      t NUMBER;',
'    BEGIN',
'      t := bitand(x,',
'                  bmax32);',
'      RETURN bitand(bitor(shr(t,',
'                              b),',
'                          shl(t,',
'                              32 - b)),',
'                    bmax32);',
'    END;',
'    --',
'    FUNCTION rol32(x NUMBER,',
'                   b PLS_INTEGER) RETURN NUMBER IS',
'      t NUMBER;',
'    BEGIN',
'      t := bitand(x,',
'                  bmax32);',
'      RETURN bitand(bitor(shl(t,',
'                              b),',
'                          shr(t,',
'                              32 - b)),',
'                    bmax32);',
'    END;',
'    --',
'    FUNCTION ror64(x NUMBER,',
'                   b PLS_INTEGER) RETURN NUMBER IS',
'      t NUMBER;',
'    BEGIN',
'      t := bitand(x,',
'                  bmax64);',
'      RETURN bitand(bitor(shr(t,',
'                              b),',
'                          shl(t,',
'                              64 - b)),',
'                    bmax64);',
'    END;',
'    --',
'    FUNCTION rol64(x NUMBER,',
'                   b PLS_INTEGER) RETURN NUMBER IS',
'      t NUMBER;',
'    BEGIN',
'      t := bitand(x,',
'                  bmax64);',
'      RETURN bitand(bitor(shl(t,',
'                              b),',
'                          shr(t,',
'                              64 - b)),',
'                    bmax64);',
'    END;',
'    --',
'  BEGIN',
'    l_msg     := utl_raw.cast_to_raw(p_msg);',
'    t_len     := nvl(utl_raw.length(l_msg),',
'                     0);',
'    t_pad_len := 64 - MOD(t_len,',
'                          64);',
'    IF t_pad_len < 9 THEN',
'      t_pad_len := 64 + t_pad_len;',
'    END IF;',
'    t_pad := rpad(''8'',',
'                  t_pad_len * 2 - 8,',
'                  ''0'') || to_char(t_len * 8,',
'                                  ''fm0XXXXXXX'');',
'    --',
'    h_str := ''6a09e667bb67ae853c6ef372a54ff53a510e527f9b05688c1f83d9ab5be0cd19'';',
'    ht    := tp_tab();',
'    ht.extend(8);',
'    FOR i IN 1 .. 8 LOOP',
'      ht(i) := to_number(substr(h_str,',
'                                i * 8 - 7,',
'                                8),',
'                         fmt1);',
'    END LOOP;',
'    --',
'    k_str := ''428a2f9871374491b5c0fbcfe9b5dba53956c25b59f111f1923f82a4ab1c5ed5'' ||',
'             ''d807aa9812835b01243185be550c7dc372be5d7480deb1fe9bdc06a7c19bf174'' ||',
'             ''e49b69c1efbe47860fc19dc6240ca1cc2de92c6f4a7484aa5cb0a9dc76f988da'' ||',
'             ''983e5152a831c66db00327c8bf597fc7c6e00bf3d5a7914706ca635114292967'' ||',
'             ''27b70a852e1b21384d2c6dfc53380d13650a7354766a0abb81c2c92e92722c85'' ||',
'             ''a2bfe8a1a81a664bc24b8b70c76c51a3d192e819d6990624f40e3585106aa070'' ||',
'             ''19a4c1161e376c082748774c34b0bcb5391c0cb34ed8aa4a5b9cca4f682e6ff3'' ||',
'             ''748f82ee78a5636f84c878148cc7020890befffaa4506cebbef9a3f7c67178f2'';',
'    k     := tp_tab();',
'    k.extend(64);',
'    FOR i IN 1 .. 64 LOOP',
'      k(i) := to_number(substr(k_str,',
'                               i * 8 - 7,',
'                               8),',
'                        fmt1);',
'    END LOOP;',
'    --',
'    t_idx := 1;',
'    WHILE t_idx <= t_len + t_pad_len LOOP',
'      IF t_len - t_idx + 1 >= t_chunksize THEN',
'        t_msg_buf := utl_raw.substr(l_msg,',
'                                    t_idx,',
'                                    t_chunksize);',
'        t_idx     := t_idx + t_chunksize;',
'      ELSE',
'        IF t_idx <= t_len THEN',
'          t_msg_buf := utl_raw.substr(l_msg,',
'                                      t_idx);',
'          t_idx     := t_len + 1;',
'        ELSE',
'          t_msg_buf := '''';',
'        END IF;',
'        IF nvl(length(t_msg_buf),',
'               0) + t_pad_len * 2 <= 32766 THEN',
'          t_msg_buf := t_msg_buf || t_pad;',
'          t_idx     := t_idx + t_pad_len;',
'        END IF;',
'      END IF;',
'      --',
'      FOR i IN 1 .. length(t_msg_buf) / 128 LOOP',
'        --',
'        a := ht(1);',
'        b := ht(2);',
'        c := ht(3);',
'        d := ht(4);',
'        e := ht(5);',
'        f := ht(6);',
'        g := ht(7);',
'        h := ht(8);',
'        --',
'        t_block := substr(t_msg_buf,',
'                          i * 128 - 127,',
'                          128);',
'        w       := tp_tab();',
'        w.extend(64);',
'        FOR j IN 1 .. 16 LOOP',
'          w(j) := to_number(substr(t_block,',
'                                   j * 8 - 7,',
'                                   8),',
'                            fmt1);',
'        END LOOP;',
'        --',
'        FOR j IN 17 .. 64 LOOP',
'          tmp := w(j - 15);',
'          s0 := bitxor(bitxor(ror32(tmp,',
'                                    7),',
'                              ror32(tmp,',
'                                    18)),',
'                       shr(tmp,',
'                           3));',
'          tmp := w(j - 2);',
'          s1 := bitxor(bitxor(ror32(tmp,',
'                                    17),',
'                              ror32(tmp,',
'                                    19)),',
'                       shr(tmp,',
'                           10));',
'          w(j) := bitand(w(j - 16) + s0 + w(j - 7) + s1,',
'                         bmax32);',
'        END LOOP;',
'        --',
'        FOR j IN 1 .. 64 LOOP',
'          s0  := bitxor(bitxor(ror32(a,',
'                                     2),',
'                               ror32(a,',
'                                     13)),',
'                        ror32(a,',
'                              22));',
'          maj := bitxor(bitxor(bitand(a,',
'                                      b),',
'                               bitand(a,',
'                                      c)),',
'                        bitand(b,',
'                               c));',
'          t2  := bitand(s0 + maj,',
'                        bmax32);',
'          s1  := bitxor(bitxor(ror32(e,',
'                                     6),',
'                               ror32(e,',
'                                     11)),',
'                        ror32(e,',
'                              25));',
'          ch  := bitxor(bitand(e,',
'                               f),',
'                        bitand(-e - 1,',
'                               g));',
'          t1  := h + s1 + ch + k(j) + w(j);',
'          h   := g;',
'          g   := f;',
'          f   := e;',
'          e   := d + t1;',
'          d   := c;',
'          c   := b;',
'          b   := a;',
'          a   := t1 + t2;',
'        END LOOP;',
'        --',
'        ht(1) := bitand(ht(1) + a,',
'                        bmax32);',
'        ht(2) := bitand(ht(2) + b,',
'                        bmax32);',
'        ht(3) := bitand(ht(3) + c,',
'                        bmax32);',
'        ht(4) := bitand(ht(4) + d,',
'                        bmax32);',
'        ht(5) := bitand(ht(5) + e,',
'                        bmax32);',
'        ht(6) := bitand(ht(6) + f,',
'                        bmax32);',
'        ht(7) := bitand(ht(7) + g,',
'                        bmax32);',
'        ht(8) := bitand(ht(8) + h,',
'                        bmax32);',
'        --',
'      END LOOP;',
'    END LOOP;',
'    FOR i IN 1 .. 8 LOOP',
'      t_md := t_md || to_char(ht(i),',
'                              fmt2);',
'    END LOOP;',
'    RETURN t_md;',
'  END sha256;',
'  --',
'  -- Get DA internal event name',
'  FUNCTION get_da_event_name(p_action_id IN NUMBER) RETURN VARCHAR2 IS',
'    --',
'    l_da_event_name apex_application_page_da.when_event_internal_name%TYPE;',
'    l_app_id        NUMBER;',
'    --',
'    CURSOR l_cur_da_event IS',
'      SELECT aapd.when_event_internal_name',
'        FROM apex_application_page_da      aapd,',
'             apex_application_page_da_acts aapda',
'       WHERE aapd.dynamic_action_id = aapda.dynamic_action_id',
'         AND aapd.application_id = l_app_id',
'         AND aapda.action_id = p_action_id;',
'    --',
'  BEGIN',
'    --',
'    l_app_id := nv(''APP_ID'');',
'    --',
'    OPEN l_cur_da_event;',
'    FETCH l_cur_da_event',
'      INTO l_da_event_name;',
'    CLOSE l_cur_da_event;',
'    --',
'    RETURN nvl(l_da_event_name,',
'               ''ready'');',
'    --',
'  END get_da_event_name;',
'  --',
'BEGIN',
'  --',
'  l_analytics_id_string := v(''INSTANCE_ID'') || '':'' || v(''WORKSPACE_ID'') || '':'' || v(''APP_ID'') || '':'' || v(''APP_USER'');',
'  l_analytics_id        := sha256(p_msg => l_analytics_id_string);',
'  -- build component config json',
'  apex_json.initialize_clob_output;',
'  apex_json.open_object();',
'  -- general',
'  apex_json.write(''analyticsId'',',
'                  l_analytics_id);',
'  apex_json.write(''eventName'',',
'                  get_da_event_name(p_action_id => p_dynamic_action.id));',
'  -- app wide attributes',
'  apex_json.write(''analyticsRestUrl'',',
'                  l_analytics_rest_url);',
'  -- component attributes',
'  apex_json.write(''additionalInfoItem'',',
'                  l_additional_info_item);',
'  apex_json.write(''encodeWebserviceCall'',',
'                  l_encode_webservice_call);',
'  apex_json.write(''stopOnMaxError'',',
'                  l_stop_on_max_error);',
'  apex_json.write(''respectDoNotTrack'',',
'                  l_respect_donottrack);',
'  apex_json.close_object();',
'  --',
'  l_component_config_json := apex_json.get_clob_output;',
'  apex_json.free_output;',
'  -- DA javascript function',
'  l_result.javascript_function := ''function() { apex.da.apexAnalytics.pluginHandler('' || l_component_config_json ||',
'                                  ''); }'';',
'  --',
'  RETURN l_result;',
'  --',
'END render_apexanalytics;'))
,p_api_version=>2
,p_render_function=>'render_apexanalytics'
,p_substitute_attributes=>true
,p_subscribe_plugin_settings=>true
,p_help_text=>'<p>APEX Analytics is a Dynamic Action plugin which collects client / browser information and sends this to an REST endpoint.</p>'
,p_version_identifier=>'1.0.6'
,p_about_url=>'https://github.com/Dani3lSun/apex-plugin-analytics'
,p_files_version=>1220
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(6302535965038691)
,p_plugin_id=>wwv_flow_api.id(6269942285913443)
,p_attribute_scope=>'APPLICATION'
,p_attribute_sequence=>1
,p_display_sequence=>10
,p_prompt=>'Analytics REST Web Service URL'
,p_attribute_type=>'TEXT'
,p_is_required=>true
,p_is_translatable=>true
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>URL of the APEX Analytics server side REST endpoint (ORDS).</p>',
'<p>e.g. https://example.com/ords/apex_analytics/data/collect </p>'))
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(1751713454516847)
,p_plugin_id=>wwv_flow_api.id(6269942285913443)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>1
,p_display_sequence=>10
,p_prompt=>'Additional Info Item'
,p_attribute_type=>'PAGE ITEM'
,p_is_required=>false
,p_is_translatable=>false
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>Next to the standard information which the plugin collects and sends to the REST endpoint, you have the possibility to send additional information to the server side, which are saved there.</p>',
'<p>Please provide a item which holds that information.</p>'))
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(1752232321519294)
,p_plugin_id=>wwv_flow_api.id(6269942285913443)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>2
,p_display_sequence=>20
,p_prompt=>'Encode Web Service Call'
,p_attribute_type=>'CHECKBOX'
,p_is_required=>false
,p_default_value=>'N'
,p_is_translatable=>false
,p_examples=>wwv_flow_string.join(wwv_flow_t_varchar2(
'Plain JSON example:<br>',
'<pre>',
'{',
'  "encodeWebserviceCall": "N",',
'  "analyticsId": "CA16B5B10AA6953DAF0E350BB6CCE7A979AB572FB24540540F2BE10406D75340",',
'  "agentName": "Chrome",',
'  "agentVersion": "71.0.3578.98",',
'  "agentLanguage": "en-US",',
'  "osName": "Mac OS",',
'  "osVersion": "10.14.2",',
'  "hasTouchSupport": "N",',
'  "pageLoadTime": 1.267,',
'  "screenWidth": 1680,',
'  "screenHeight": 1050,',
'  "apexAppId": "280",',
'  "apexPageId": "1",',
'  "eventName": "ready",',
'  "additionalInfo": ""',
'}',
'</pre>',
'<br>',
'Base64 encoded JSON example:<br>',
'<pre>',
'{',
'  "encodeWebserviceCall": "Y",',
'  "encodedString": "Q0ExNkI1QjEwQUE2OTUzREFGMEUzNTBCQjZDQ0U3QTk3OUFCNTcyRkIyNDU0MDU0MEYyQkUxMDQwNkQ3NTM0MDo6OkNocm9tZTo6OjcxLjAuMzU3OC45ODo6Ok1hYyBPUzo6OjEwLjE0LjI6OjpOOjo6MS4wNzc6OjoxNjgwOjo6MTA1MDo6OjI4MDo6OjE6OjpyZWFkeTo6Og=="',
'}',
'</pre>'))
,p_help_text=>'<p>The plugin sends a JSON payload via a RESTful POST call. Please decide if this payload is sent with plain information or base64 encoded to hide certain information on first sight.</p>'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(1754011660289506)
,p_plugin_id=>wwv_flow_api.id(6269942285913443)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>3
,p_display_sequence=>30
,p_prompt=>'Stop on max. Error Count'
,p_attribute_type=>'INTEGER'
,p_is_required=>true
,p_default_value=>'3'
,p_is_translatable=>false
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>If the REST endpoint is not reachable for some reason or there are other problems, an error counter is set in browsers session storage.</p>',
'<p>If the counter value in session storage exceeds the max allowed counter value, collection & sending information to the server side stops.</p>'))
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(3001020818017339)
,p_plugin_id=>wwv_flow_api.id(6269942285913443)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>4
,p_display_sequence=>40
,p_prompt=>'Respect DoNotTrack Setting'
,p_attribute_type=>'CHECKBOX'
,p_is_required=>false
,p_default_value=>'N'
,p_is_translatable=>false
,p_help_text=>'<p>Respect the users browser DoNotTrack setting and do not collect & send information to the REST endpoint.</p>'
);
wwv_flow_api.create_plugin_event(
 p_id=>wwv_flow_api.id(6376548040427695)
,p_plugin_id=>wwv_flow_api.id(6269942285913443)
,p_name=>'apexanalytics-ajax-error'
,p_display_name=>'Web Service Call Error'
);
wwv_flow_api.create_plugin_event(
 p_id=>wwv_flow_api.id(6376152689427694)
,p_plugin_id=>wwv_flow_api.id(6269942285913443)
,p_name=>'apexanalytics-ajax-success'
,p_display_name=>'Web Service Call Success'
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '617065782E64612E61706578416E616C79746963733D7B706C7567696E48616E646C65723A66756E6374696F6E2865297B76617220613D7B63616C6C416E616C7974696373576562736572766963653A66756E6374696F6E28652C612C72297B7472797B';
wwv_flow_api.g_varchar2_table(2) := '242E616A6178287B75726C3A652C747970653A22504F5354222C646174613A4A534F4E2E737472696E676966792861292C636F6E74656E74547970653A226170706C69636174696F6E2F6A736F6E3B20636861727365743D7574662D38222C6461746154';
wwv_flow_api.g_varchar2_table(3) := '7970653A226A736F6E222C737563636573733A66756E6374696F6E2865297B652E737563636573733F28617065782E6576656E742E747269676765722822626F6479222C2261706578616E616C79746963732D616A61782D73756363657373222C65292C';
wwv_flow_api.g_varchar2_table(4) := '617065782E64656275672E6C6F67282261706578416E616C79746963732E63616C6C416E616C79746963735765627365727669636520414A41582053756363657373222C65292C72287B737563636573733A21307D29293A28617065782E6576656E742E';
wwv_flow_api.g_varchar2_table(5) := '747269676765722822626F6479222C2261706578616E616C79746963732D616A61782D6572726F72222C7B6D6573736167653A652E6D6573736167657D292C617065782E64656275672E6C6F67282261706578416E616C79746963732E63616C6C416E61';
wwv_flow_api.g_varchar2_table(6) := '6C79746963735765627365727669636520414A4158204572726F72222C652E6D657373616765292C72287B737563636573733A21317D29297D2C6572726F723A66756E6374696F6E28652C612C6E297B617065782E6576656E742E747269676765722822';
wwv_flow_api.g_varchar2_table(7) := '626F6479222C2261706578616E616C79746963732D616A61782D6572726F72222C7B6D6573736167653A6E7D292C617065782E64656275672E6C6F67282261706578416E616C79746963732E63616C6C416E616C79746963735765627365727669636520';
wwv_flow_api.g_varchar2_table(8) := '414A4158204572726F72222C6E292C72287B737563636573733A21317D297D7D297D63617463682865297B617065782E6576656E742E747269676765722822626F6479222C2261706578616E616C79746963732D616A61782D6572726F72222C7B6D6573';
wwv_flow_api.g_varchar2_table(9) := '736167653A657D292C617065782E64656275672E6C6F67282261706578416E616C79746963732E63616C6C416E616C79746963735765627365727669636520414A4158204572726F72222C65292C72287B737563636573733A21317D297D7D2C73657441';
wwv_flow_api.g_varchar2_table(10) := '6E616C79746963734572726F7253657373696F6E53746F726167653A66756E6374696F6E2865297B696628617065782E73746F726167652E68617353657373696F6E53746F72616765537570706F72742829297B76617220613D2476282270496E737461';
wwv_flow_api.g_varchar2_table(11) := '6E636522293B617065782E73746F726167652E67657453636F70656453657373696F6E53746F72616765287B7072656669783A2261706578416E616C7974696373222C75736541707049643A21307D292E7365744974656D28612B222E6572726F72436F';
wwv_flow_api.g_varchar2_table(12) := '756E74222C65297D7D2C676574416E616C79746963734572726F7253657373696F6E53746F726167653A66756E6374696F6E28297B76617220653B696628617065782E73746F726167652E68617353657373696F6E53746F72616765537570706F727428';
wwv_flow_api.g_varchar2_table(13) := '29297B76617220613D2476282270496E7374616E636522293B653D617065782E73746F726167652E67657453636F70656453657373696F6E53746F72616765287B7072656669783A2261706578416E616C7974696373222C75736541707049643A21307D';
wwv_flow_api.g_varchar2_table(14) := '292E6765744974656D28612B222E6572726F72436F756E7422297D72657475726E20657C7C2230227D2C7365744572726F72436F756E7455703A66756E6374696F6E28297B76617220653D7061727365496E7428612E676574416E616C79746963734572';
wwv_flow_api.g_varchar2_table(15) := '726F7253657373696F6E53746F726167652829292B313B612E736574416E616C79746963734572726F7253657373696F6E53746F726167652865297D2C636865636B4572726F72436F756E743A66756E6374696F6E2865297B72657475726E2070617273';
wwv_flow_api.g_varchar2_table(16) := '65496E7428612E676574416E616C79746963734572726F7253657373696F6E53746F726167652829292B313C3D657D2C686173546F756368537570706F72743A66756E6374696F6E28297B72657475726E226F6E746F756368737461727422696E207769';
wwv_flow_api.g_varchar2_table(17) := '6E646F777C7C6E6176696761746F722E6D734D6178546F756368506F696E74733E303F2259223A224E227D2C67657453637265656E57696474683A66756E6374696F6E28297B72657475726E2077696E646F772E73637265656E2E77696474687C7C307D';
wwv_flow_api.g_varchar2_table(18) := '2C67657453637265656E4865696768743A66756E6374696F6E28297B72657475726E2077696E646F772E73637265656E2E6865696768747C7C307D2C67657442726F777365724C616E67756167653A66756E6374696F6E28297B72657475726E206E6176';
wwv_flow_api.g_varchar2_table(19) := '696761746F722E6C616E6775616765733F6E6176696761746F722E6C616E6775616765735B305D3A6E6176696761746F722E6C616E67756167657C7C6E6176696761746F722E757365724C616E67756167657D2C676574506167654C6F616454696D653A';
wwv_flow_api.g_varchar2_table(20) := '66756E6374696F6E2865297B76617220613B696628227265616479223D3D65297B613D28286E65772044617465292E67657454696D6528292D706572666F726D616E63652E74696D696E672E6E617669676174696F6E5374617274292F3165337D656C73';
wwv_flow_api.g_varchar2_table(21) := '6520613D303B72657475726E20617C7C307D2C6973446F4E6F74547261636B4163746976653A66756E6374696F6E28297B72657475726E21212877696E646F772E646F4E6F74547261636B7C7C6E6176696761746F722E646F4E6F74547261636B7C7C6E';
wwv_flow_api.g_varchar2_table(22) := '6176696761746F722E6D73446F4E6F74547261636B7C7C226D73547261636B696E6750726F74656374696F6E456E61626C656422696E2077696E646F772E65787465726E616C2926262128223122213D77696E646F772E646F4E6F74547261636B262622';
wwv_flow_api.g_varchar2_table(23) := '79657322213D6E6176696761746F722E646F4E6F74547261636B2626223122213D6E6176696761746F722E646F4E6F74547261636B2626223122213D6E6176696761746F722E6D73446F4E6F74547261636B26262177696E646F772E65787465726E616C';
wwv_flow_api.g_varchar2_table(24) := '2E6D73547261636B696E6750726F74656374696F6E456E61626C65642829297D2C6973446F4E6F74547261636B436F6D706C6574654163746976653A66756E6374696F6E2865297B72657475726E2259223D3D6526262121612E6973446F4E6F74547261';
wwv_flow_api.g_varchar2_table(25) := '636B41637469766528297D2C6275696C64416E616C79746963734A736F6E3A66756E6374696F6E28652C722C6E2C74297B766172206F3D286E6577205541506172736572292E676574526573756C7428292C733D7B7D2C693D22223B72657475726E206F';
wwv_flow_api.g_varchar2_table(26) := '2E62726F777365722E6E616D6526266F2E62726F777365722E76657273696F6E26266F2E6F732E6E616D6526266F2E6F732E76657273696F6E262628224E223D3D743F733D7B656E636F64655765627365727669636543616C6C3A742C616E616C797469';
wwv_flow_api.g_varchar2_table(27) := '637349643A652C6167656E744E616D653A6F2E62726F777365722E6E616D652C6167656E7456657273696F6E3A6F2E62726F777365722E76657273696F6E2C6167656E744C616E67756167653A612E67657442726F777365724C616E677561676528292C';
wwv_flow_api.g_varchar2_table(28) := '6F734E616D653A6F2E6F732E6E616D652C6F7356657273696F6E3A6F2E6F732E76657273696F6E2C686173546F756368537570706F72743A612E686173546F756368537570706F727428292C706167654C6F616454696D653A612E676574506167654C6F';
wwv_flow_api.g_varchar2_table(29) := '616454696D652872292C73637265656E57696474683A612E67657453637265656E576964746828292C73637265656E4865696768743A612E67657453637265656E48656967687428292C6170657841707049643A2476282270466C6F77496422292C6170';
wwv_flow_api.g_varchar2_table(30) := '65785061676549643A2476282270466C6F7753746570496422292C6576656E744E616D653A722C6164646974696F6E616C496E666F3A2476286E297D3A28693D652B223A3A3A222C692B3D6F2E62726F777365722E6E616D652B223A3A3A222C692B3D6F';
wwv_flow_api.g_varchar2_table(31) := '2E62726F777365722E76657273696F6E2B223A3A3A222C692B3D612E67657442726F777365724C616E677561676528292B223A3A3A222C692B3D6F2E6F732E6E616D652B223A3A3A222C692B3D6F2E6F732E76657273696F6E2B223A3A3A222C692B3D61';
wwv_flow_api.g_varchar2_table(32) := '2E686173546F756368537570706F727428292B223A3A3A222C692B3D612E676574506167654C6F616454696D652872292B223A3A3A222C692B3D612E67657453637265656E576964746828292B223A3A3A222C692B3D612E67657453637265656E486569';
wwv_flow_api.g_varchar2_table(33) := '67687428292B223A3A3A222C692B3D2476282270466C6F77496422292B223A3A3A222C692B3D2476282270466C6F7753746570496422292B223A3A3A222C692B3D722B223A3A3A222C692B3D2476286E292C733D7B656E636F6465576562736572766963';
wwv_flow_api.g_varchar2_table(34) := '6543616C6C3A742C656E636F646564537472696E673A62746F612869297D29292C737D2C706C7567696E48616E646C65723A66756E6374696F6E2865297B76617220723D652E616E616C797469637349642C6E3D652E6576656E744E616D652C743D652E';
wwv_flow_api.g_varchar2_table(35) := '616E616C79746963735265737455726C2C6F3D652E6164646974696F6E616C496E666F4974656D2C733D652E656E636F64655765627365727669636543616C6C2C693D652E73746F704F6E4D61784572726F722C633D652E72657370656374446F4E6F74';
wwv_flow_api.g_varchar2_table(36) := '547261636B3B696628617065782E64656275672E6C6F67282261706578416E616C79746963732E706C7567696E48616E646C6572202D20616E616C79746963734964222C72292C617065782E64656275672E6C6F67282261706578416E616C7974696373';
wwv_flow_api.g_varchar2_table(37) := '2E706C7567696E48616E646C6572202D206576656E744E616D65222C6E292C617065782E64656275672E6C6F67282261706578416E616C79746963732E706C7567696E48616E646C6572202D20616E616C79746963735265737455726C222C74292C6170';
wwv_flow_api.g_varchar2_table(38) := '65782E64656275672E6C6F67282261706578416E616C79746963732E706C7567696E48616E646C6572202D206164646974696F6E616C496E666F4974656D222C6F292C617065782E64656275672E6C6F67282261706578416E616C79746963732E706C75';
wwv_flow_api.g_varchar2_table(39) := '67696E48616E646C6572202D20656E636F64655765627365727669636543616C6C222C73292C617065782E64656275672E6C6F67282261706578416E616C79746963732E706C7567696E48616E646C6572202D2073746F704F6E4D61784572726F72222C';
wwv_flow_api.g_varchar2_table(40) := '69292C617065782E64656275672E6C6F67282261706578416E616C79746963732E706C7567696E48616E646C6572202D2072657370656374446F4E6F74547261636B222C63292C21612E6973446F4E6F74547261636B436F6D706C657465416374697665';
wwv_flow_api.g_varchar2_table(41) := '2863292626612E636865636B4572726F72436F756E74286929297B76617220673D612E6275696C64416E616C79746963734A736F6E28722C6E2C6F2C73293B673F612E63616C6C416E616C79746963735765627365727669636528742C672C66756E6374';
wwv_flow_api.g_varchar2_table(42) := '696F6E2865297B652E737563636573737C7C612E7365744572726F72436F756E74557028297D293A612E7365744572726F72436F756E74557028297D7D7D3B7472797B612E706C7567696E48616E646C65722865297D63617463682865297B617065782E';
wwv_flow_api.g_varchar2_table(43) := '64656275672E6C6F67282261706578416E616C79746963732E706C7567696E48616E646C6572206572726F72222C65292C612E7365744572726F72436F756E74557028297D7D7D3B';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(1765256399399064)
,p_plugin_id=>wwv_flow_api.id(6269942285913443)
,p_file_name=>'js/apexanalytics.min.js'
,p_mime_type=>'application/x-javascript'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '2F2A2A0A202A204150455820416E616C79746963730A202A20417574686F723A2044616E69656C20486F63686C6569746E65720A202A2056657273696F6E3A20312E302E360A202A2F0A0A2F2A2A0A202A20457874656E6420617065782E64610A202A2F';
wwv_flow_api.g_varchar2_table(2) := '0A617065782E64612E61706578416E616C7974696373203D207B0A20202F2A2A0A2020202A20506C7567696E2068616E646C6572202D2063616C6C65642066726F6D20706C7567696E2072656E6465722066756E6374696F6E0A2020202A204070617261';
wwv_flow_api.g_varchar2_table(3) := '6D207B6F626A6563747D20704F7074696F6E730A2020202A2F0A2020706C7567696E48616E646C65723A2066756E6374696F6E28704F7074696F6E7329207B0A202020202F2A2A0A20202020202A204D61696E204E616D6573706163650A20202020202A';
wwv_flow_api.g_varchar2_table(4) := '2F0A202020207661722061706578416E616C7974696373203D207B0A2020202020202F2A2A0A202020202020202A2043616C6C204150455820416E616C797469637320524553542077656220736572766963650A202020202020202A2040706172616D20';
wwv_flow_api.g_varchar2_table(5) := '7B737472696E677D2070416E616C79746963735265737455726C0A202020202020202A2040706172616D207B6F626A6563747D2070446174610A202020202020202A2040706172616D207B66756E6374696F6E7D2063616C6C6261636B0A202020202020';
wwv_flow_api.g_varchar2_table(6) := '202A2F0A20202020202063616C6C416E616C7974696373576562736572766963653A2066756E6374696F6E2870416E616C79746963735265737455726C2C2070446174612C2063616C6C6261636B29207B0A2020202020202020747279207B0A20202020';
wwv_flow_api.g_varchar2_table(7) := '202020202020242E616A6178287B0A20202020202020202020202075726C3A2070416E616C79746963735265737455726C2C0A202020202020202020202020747970653A2027504F5354272C0A202020202020202020202020646174613A204A534F4E2E';
wwv_flow_api.g_varchar2_table(8) := '737472696E67696679287044617461292C0A202020202020202020202020636F6E74656E74547970653A20276170706C69636174696F6E2F6A736F6E3B20636861727365743D7574662D38272C0A20202020202020202020202064617461547970653A20';
wwv_flow_api.g_varchar2_table(9) := '276A736F6E272C0A202020202020202020202020737563636573733A2066756E6374696F6E286461746129207B0A202020202020202020202020202069662028646174612E7375636365737329207B0A2020202020202020202020202020202061706578';
wwv_flow_api.g_varchar2_table(10) := '2E6576656E742E747269676765722827626F6479272C202761706578616E616C79746963732D616A61782D73756363657373272C2064617461293B0A20202020202020202020202020202020617065782E64656275672E6C6F67282761706578416E616C';
wwv_flow_api.g_varchar2_table(11) := '79746963732E63616C6C416E616C79746963735765627365727669636520414A41582053756363657373272C2064617461293B0A2020202020202020202020202020202063616C6C6261636B287B0A202020202020202020202020202020202020227375';
wwv_flow_api.g_varchar2_table(12) := '6363657373223A20747275650A202020202020202020202020202020207D293B0A20202020202020202020202020207D20656C7365207B0A20202020202020202020202020202020617065782E6576656E742E747269676765722827626F6479272C2027';
wwv_flow_api.g_varchar2_table(13) := '61706578616E616C79746963732D616A61782D6572726F72272C207B0A202020202020202020202020202020202020226D657373616765223A20646174612E6D6573736167650A202020202020202020202020202020207D293B0A202020202020202020';
wwv_flow_api.g_varchar2_table(14) := '20202020202020617065782E64656275672E6C6F67282761706578416E616C79746963732E63616C6C416E616C79746963735765627365727669636520414A4158204572726F72272C20646174612E6D657373616765293B0A2020202020202020202020';
wwv_flow_api.g_varchar2_table(15) := '202020202063616C6C6261636B287B0A2020202020202020202020202020202020202273756363657373223A2066616C73650A202020202020202020202020202020207D293B0A20202020202020202020202020207D0A2020202020202020202020207D';
wwv_flow_api.g_varchar2_table(16) := '2C0A2020202020202020202020206572726F723A2066756E6374696F6E286A715848522C20746578745374617475732C206572726F725468726F776E29207B0A2020202020202020202020202020617065782E6576656E742E747269676765722827626F';
wwv_flow_api.g_varchar2_table(17) := '6479272C202761706578616E616C79746963732D616A61782D6572726F72272C207B0A20202020202020202020202020202020226D657373616765223A206572726F725468726F776E0A20202020202020202020202020207D293B0A2020202020202020';
wwv_flow_api.g_varchar2_table(18) := '202020202020617065782E64656275672E6C6F67282761706578416E616C79746963732E63616C6C416E616C79746963735765627365727669636520414A4158204572726F72272C206572726F725468726F776E293B0A20202020202020202020202020';
wwv_flow_api.g_varchar2_table(19) := '2063616C6C6261636B287B0A202020202020202020202020202020202273756363657373223A2066616C73650A20202020202020202020202020207D293B0A2020202020202020202020207D0A202020202020202020207D293B0A20202020202020207D';
wwv_flow_api.g_varchar2_table(20) := '206361746368202865727229207B0A20202020202020202020617065782E6576656E742E747269676765722827626F6479272C202761706578616E616C79746963732D616A61782D6572726F72272C207B0A202020202020202020202020226D65737361';
wwv_flow_api.g_varchar2_table(21) := '6765223A206572720A202020202020202020207D293B0A20202020202020202020617065782E64656275672E6C6F67282761706578416E616C79746963732E63616C6C416E616C79746963735765627365727669636520414A4158204572726F72272C20';
wwv_flow_api.g_varchar2_table(22) := '657272293B0A2020202020202020202063616C6C6261636B287B0A2020202020202020202020202273756363657373223A2066616C73650A202020202020202020207D293B0A20202020202020207D0A2020202020207D2C0A2020202020202F2A2A0A20';
wwv_flow_api.g_varchar2_table(23) := '2020202020202A205361766520616E616C7974696373206572726F7220636F756E7420696E2062726F77736572732073657373696F6E2073746F72616765202861706578416E616C79746963732E3C6170705F69643E2E3C6170705F73657373696F6E3E';
wwv_flow_api.g_varchar2_table(24) := '2E6572726F72436F756E74290A202020202020202A2040706172616D207B6E756D6265727D20704572726F72436F756E740A202020202020202A2F0A202020202020736574416E616C79746963734572726F7253657373696F6E53746F726167653A2066';
wwv_flow_api.g_varchar2_table(25) := '756E6374696F6E28704572726F72436F756E7429207B0A202020202020202069662028617065782E73746F726167652E68617353657373696F6E53746F72616765537570706F7274282929207B0A20202020202020202020766172206170657853657373';
wwv_flow_api.g_varchar2_table(26) := '696F6E203D202476282770496E7374616E636527293B0A202020202020202020207661722073657373696F6E53746F72616765203D20617065782E73746F726167652E67657453636F70656453657373696F6E53746F72616765287B0A20202020202020';
wwv_flow_api.g_varchar2_table(27) := '20202020207072656669783A202761706578416E616C7974696373272C0A20202020202020202020202075736541707049643A20747275650A202020202020202020207D293B0A0A2020202020202020202073657373696F6E53746F726167652E736574';
wwv_flow_api.g_varchar2_table(28) := '4974656D286170657853657373696F6E202B20272E6572726F72436F756E74272C20704572726F72436F756E74293B0A20202020202020207D0A2020202020207D2C0A2020202020202F2A2A0A202020202020202A2047657420616E616C797469637320';
wwv_flow_api.g_varchar2_table(29) := '6572726F7220636F756E742066726F6D2062726F77736572732073657373696F6E2073746F72616765202861706578416E616C79746963732E3C6170705F69643E2E3C6170705F73657373696F6E3E2E6572726F72436F756E74290A202020202020202A';
wwv_flow_api.g_varchar2_table(30) := '204072657475726E207B737472696E677D0A202020202020202A2F0A202020202020676574416E616C79746963734572726F7253657373696F6E53746F726167653A2066756E6374696F6E2829207B0A20202020202020207661722073746F7261676556';
wwv_flow_api.g_varchar2_table(31) := '616C75653B0A0A202020202020202069662028617065782E73746F726167652E68617353657373696F6E53746F72616765537570706F7274282929207B0A20202020202020202020766172206170657853657373696F6E203D202476282770496E737461';
wwv_flow_api.g_varchar2_table(32) := '6E636527293B0A202020202020202020207661722073657373696F6E53746F72616765203D20617065782E73746F726167652E67657453636F70656453657373696F6E53746F72616765287B0A2020202020202020202020207072656669783A20276170';
wwv_flow_api.g_varchar2_table(33) := '6578416E616C7974696373272C0A20202020202020202020202075736541707049643A20747275650A202020202020202020207D293B0A0A2020202020202020202073746F7261676556616C7565203D2073657373696F6E53746F726167652E67657449';
wwv_flow_api.g_varchar2_table(34) := '74656D286170657853657373696F6E202B20272E6572726F72436F756E7427293B0A20202020202020207D0A202020202020202072657475726E2073746F7261676556616C7565207C7C202730273B0A2020202020207D2C0A2020202020202F2A2A0A20';
wwv_flow_api.g_varchar2_table(35) := '2020202020202A205261697365206572726F7220636F756E742069732073657373696F6E2073746F72616765202B20310A202020202020202A2F0A2020202020207365744572726F72436F756E7455703A2066756E6374696F6E2829207B0A2020202020';
wwv_flow_api.g_varchar2_table(36) := '202020766172206572726F72436F756E74203D207061727365496E742861706578416E616C79746963732E676574416E616C79746963734572726F7253657373696F6E53746F72616765282929202B20313B0A202020202020202061706578416E616C79';
wwv_flow_api.g_varchar2_table(37) := '746963732E736574416E616C79746963734572726F7253657373696F6E53746F72616765286572726F72436F756E74293B0A2020202020207D2C0A2020202020202F2A2A0A202020202020202A20436865636B206966206572726F7220636F756E742069';
wwv_flow_api.g_varchar2_table(38) := '6E2073657373696F6E2073746F7261676520657863656564206D617820616C6C6F776564206572726F7220636F756E740A202020202020202A2040706172616D207B6E756D6265727D20704D61784572726F72436F756E740A202020202020202A204072';
wwv_flow_api.g_varchar2_table(39) := '657475726E207B626F6F6C65616E7D0A202020202020202A2F0A202020202020636865636B4572726F72436F756E743A2066756E6374696F6E28704D61784572726F72436F756E7429207B0A2020202020202020766172206572726F72436F756E74203D';
wwv_flow_api.g_varchar2_table(40) := '207061727365496E742861706578416E616C79746963732E676574416E616C79746963734572726F7253657373696F6E53746F72616765282929202B20313B0A202020202020202076617220626F6F6C56616C203D2066616C73653B0A20202020202020';
wwv_flow_api.g_varchar2_table(41) := '20696620286572726F72436F756E74203C3D20704D61784572726F72436F756E7429207B0A20202020202020202020626F6F6C56616C203D20747275653B0A20202020202020207D20656C7365207B0A20202020202020202020626F6F6C56616C203D20';
wwv_flow_api.g_varchar2_table(42) := '66616C73653B0A20202020202020207D0A202020202020202072657475726E20626F6F6C56616C3B0A2020202020207D2C0A2020202020202F2A2A0A202020202020202A20436865636B2069662062726F777365722068617320746F7563682073757070';
wwv_flow_api.g_varchar2_table(43) := '6F72740A202020202020202A204072657475726E207B737472696E677D0A202020202020202A2F0A202020202020686173546F756368537570706F72743A2066756E6374696F6E2829207B0A20202020202020207661722072657475726E56616C203D20';
wwv_flow_api.g_varchar2_table(44) := '274E273B0A202020202020202076617220686173546F756368537570706F7274203D202828276F6E746F75636873746172742720696E2077696E646F7729207C7C20286E6176696761746F722E6D734D6178546F756368506F696E7473203E203029293B';
wwv_flow_api.g_varchar2_table(45) := '0A202020202020202069662028686173546F756368537570706F727429207B0A2020202020202020202072657475726E56616C203D202759273B0A20202020202020207D20656C7365207B0A2020202020202020202072657475726E56616C203D20274E';
wwv_flow_api.g_varchar2_table(46) := '273B0A20202020202020207D0A202020202020202072657475726E2072657475726E56616C3B0A2020202020207D2C0A2020202020202F2A2A0A202020202020202A204765742073637265656E207769647468206F662077696E646F77202F2062726F77';
wwv_flow_api.g_varchar2_table(47) := '7365720A202020202020202A204072657475726E207B6E756D6265727D0A202020202020202A2F0A20202020202067657453637265656E57696474683A2066756E6374696F6E2829207B0A20202020202020207661722073637265656E5769647468203D';
wwv_flow_api.g_varchar2_table(48) := '2077696E646F772E73637265656E2E77696474683B0A202020202020202072657475726E2073637265656E5769647468207C7C20303B0A2020202020207D2C0A2020202020202F2A2A0A202020202020202A204765742073637265656E20686569676874';
wwv_flow_api.g_varchar2_table(49) := '206F662077696E646F77202F2062726F777365720A202020202020202A204072657475726E207B6E756D6265727D0A202020202020202A2F0A20202020202067657453637265656E4865696768743A2066756E6374696F6E2829207B0A20202020202020';
wwv_flow_api.g_varchar2_table(50) := '207661722073637265656E686569676874203D2077696E646F772E73637265656E2E6865696768743B0A202020202020202072657475726E2073637265656E686569676874207C7C20303B0A2020202020207D2C0A2020202020202F2A2A0A2020202020';
wwv_flow_api.g_varchar2_table(51) := '20202A20476574206D61696E206C616E6775616765206F662062726F777365720A202020202020202A204072657475726E207B737472696E677D0A202020202020202A2F0A20202020202067657442726F777365724C616E67756167653A2066756E6374';
wwv_flow_api.g_varchar2_table(52) := '696F6E2829207B0A20202020202020207661722062726F777365724C616E6775616765203D206E6176696761746F722E6C616E677561676573203F206E6176696761746F722E6C616E6775616765735B305D203A20286E6176696761746F722E6C616E67';
wwv_flow_api.g_varchar2_table(53) := '75616765207C7C206E6176696761746F722E757365724C616E6775616765293B0A202020202020202072657475726E2062726F777365724C616E67756167653B0A2020202020207D2C0A2020202020202F2A2A0A202020202020202A2047657420706167';
wwv_flow_api.g_varchar2_table(54) := '65206C6F61642074696D6520696E207365636F6E647320666F7220646F63756D656E74207265616479206576656E740A202020202020202A2040706172616D207B737472696E677D20704576656E740A202020202020202A204072657475726E207B6E75';
wwv_flow_api.g_varchar2_table(55) := '6D6265727D0A202020202020202A2F0A202020202020676574506167654C6F616454696D653A2066756E6374696F6E28704576656E7429207B0A202020202020202076617220706167654C6F616454696D653B0A20202020202020206966202870457665';
wwv_flow_api.g_varchar2_table(56) := '6E74203D3D202772656164792729207B0A20202020202020202020766172206E6F77203D206E6577204461746528292E67657454696D6528293B0A20202020202020202020706167654C6F616454696D65203D20286E6F77202D20706572666F726D616E';
wwv_flow_api.g_varchar2_table(57) := '63652E74696D696E672E6E617669676174696F6E537461727429202F20313030303B0A20202020202020207D20656C7365207B0A20202020202020202020706167654C6F616454696D65203D20303B0A20202020202020207D0A20202020202020207265';
wwv_flow_api.g_varchar2_table(58) := '7475726E20706167654C6F616454696D65207C7C20303B0A2020202020207D2C0A2020202020202F2A2A0A202020202020202A20436865636B20696620446F4E6F74547261636B2062726F777365722073657474696E67206973206163746976650A2020';
wwv_flow_api.g_varchar2_table(59) := '20202020202A204072657475726E207B626F6F6C65616E7D0A202020202020202A2F0A2020202020206973446F4E6F74547261636B4163746976653A2066756E6374696F6E2829207B0A2020202020202020766172206973416374697665203D2066616C';
wwv_flow_api.g_varchar2_table(60) := '73653B0A20202020202020202F2F20636865636B2069662062726F7773657220737570706F727420444E540A20202020202020206966202877696E646F772E646F4E6F74547261636B207C7C206E6176696761746F722E646F4E6F74547261636B207C7C';
wwv_flow_api.g_varchar2_table(61) := '206E6176696761746F722E6D73446F4E6F74547261636B207C7C20276D73547261636B696E6750726F74656374696F6E456E61626C65642720696E2077696E646F772E65787465726E616C29207B0A202020202020202020202F2F206973206163746976';
wwv_flow_api.g_varchar2_table(62) := '650A202020202020202020206966202877696E646F772E646F4E6F74547261636B203D3D20223122207C7C206E6176696761746F722E646F4E6F74547261636B203D3D202279657322207C7C206E6176696761746F722E646F4E6F74547261636B203D3D';
wwv_flow_api.g_varchar2_table(63) := '20223122207C7C206E6176696761746F722E6D73446F4E6F74547261636B203D3D20223122207C7C2077696E646F772E65787465726E616C2E6D73547261636B696E6750726F74656374696F6E456E61626C6564282929207B0A20202020202020202020';
wwv_flow_api.g_varchar2_table(64) := '20206973416374697665203D20747275653B0A2020202020202020202020202F2F206973206E6F74206163746976650A202020202020202020207D20656C7365207B0A2020202020202020202020206973416374697665203D2066616C73653B0A202020';
wwv_flow_api.g_varchar2_table(65) := '202020202020207D0A202020202020202020202F2F20646F6573206E6F7420737570706F727420444E540A20202020202020207D20656C7365207B0A202020202020202020206973416374697665203D2066616C73653B0A20202020202020207D0A2020';
wwv_flow_api.g_varchar2_table(66) := '20202020202072657475726E2069734163746976653B0A2020202020207D2C0A2020202020202F2A2A0A202020202020202A20436865636B20696620446F4E6F74547261636B2062726F777365722073657474696E6720697320616374697665202B2061';
wwv_flow_api.g_varchar2_table(67) := '637469766174656420696E20706C7567696E2073657474696E67730A202020202020202A2040706172616D207B737472696E677D207052657370656374446F4E6F74547261636B0A202020202020202A204072657475726E207B626F6F6C65616E7D0A20';
wwv_flow_api.g_varchar2_table(68) := '2020202020202A2F0A2020202020206973446F4E6F74547261636B436F6D706C6574654163746976653A2066756E6374696F6E287052657370656374446F4E6F74547261636B29207B0A2020202020202020766172206973416374697665203D2066616C';
wwv_flow_api.g_varchar2_table(69) := '73653B0A2020202020202020696620287052657370656374446F4E6F74547261636B203D3D2027592729207B0A202020202020202020206966202861706578416E616C79746963732E6973446F4E6F74547261636B416374697665282929207B0A202020';
wwv_flow_api.g_varchar2_table(70) := '2020202020202020206973416374697665203D20747275653B0A202020202020202020207D20656C7365207B0A2020202020202020202020206973416374697665203D2066616C73653B0A202020202020202020207D0A20202020202020207D20656C73';
wwv_flow_api.g_varchar2_table(71) := '65207B0A202020202020202020206973416374697665203D2066616C73653B0A20202020202020207D0A202020202020202072657475726E2069734163746976653B0A2020202020207D2C0A2020202020202F2A2A0A202020202020202A204275696C64';
wwv_flow_api.g_varchar2_table(72) := '204A534F4E20666F7220416E616C797469637320524553542043616C6C0A202020202020202A2040706172616D207B737472696E677D2070416E616C697469637349640A202020202020202A2040706172616D207B737472696E677D20704576656E744E';
wwv_flow_api.g_varchar2_table(73) := '616D650A202020202020202A2040706172616D207B737472696E677D20704164646974696F6E616C496E666F4974656D0A202020202020202A2040706172616D207B737472696E677D2070456E636F64655765627365727669636543616C6C0A20202020';
wwv_flow_api.g_varchar2_table(74) := '2020202A204072657475726E207B6F626A6563747D0A202020202020202A2F0A2020202020206275696C64416E616C79746963734A736F6E3A2066756E6374696F6E2870416E616C697469637349642C20704576656E744E616D652C2070416464697469';
wwv_flow_api.g_varchar2_table(75) := '6F6E616C496E666F4974656D2C2070456E636F64655765627365727669636543616C6C29207B0A20202020202020202F2F2067657420636C69656E7420696E666F0A202020202020202076617220706172736572203D206E657720554150617273657228';
wwv_flow_api.g_varchar2_table(76) := '293B0A202020202020202076617220706172736572526573756C74203D207061727365722E676574526573756C7428293B0A20202020202020202F2F206275696C64204A534F4E0A202020202020202076617220616E616C79746963734A736F6E203D20';
wwv_flow_api.g_varchar2_table(77) := '7B7D3B0A202020202020202076617220656E636F646564537472696E67203D2027273B0A202020202020202076617220737472696E6744697669646572203D20273A3A3A273B0A20202020202020202F2F206F6E6C792069662075736572206167656E74';
wwv_flow_api.g_varchar2_table(78) := '2070617273696E672068617320736F6D652076616C7565730A202020202020202069662028706172736572526573756C742E62726F777365722E6E616D6520262620706172736572526573756C742E62726F777365722E76657273696F6E202626207061';
wwv_flow_api.g_varchar2_table(79) := '72736572526573756C742E6F732E6E616D6520262620706172736572526573756C742E6F732E76657273696F6E29207B0A202020202020202020202F2F206E6F7420656E636F6465640A202020202020202020206966202870456E636F64655765627365';
wwv_flow_api.g_varchar2_table(80) := '727669636543616C6C203D3D20274E2729207B0A202020202020202020202020616E616C79746963734A736F6E203D207B0A202020202020202020202020202022656E636F64655765627365727669636543616C6C223A2070456E636F64655765627365';
wwv_flow_api.g_varchar2_table(81) := '727669636543616C6C2C0A202020202020202020202020202022616E616C79746963734964223A2070416E616C697469637349642C0A2020202020202020202020202020226167656E744E616D65223A20706172736572526573756C742E62726F777365';
wwv_flow_api.g_varchar2_table(82) := '722E6E616D652C0A2020202020202020202020202020226167656E7456657273696F6E223A20706172736572526573756C742E62726F777365722E76657273696F6E2C0A2020202020202020202020202020226167656E744C616E6775616765223A2061';
wwv_flow_api.g_varchar2_table(83) := '706578416E616C79746963732E67657442726F777365724C616E677561676528292C0A2020202020202020202020202020226F734E616D65223A20706172736572526573756C742E6F732E6E616D652C0A2020202020202020202020202020226F735665';
wwv_flow_api.g_varchar2_table(84) := '7273696F6E223A20706172736572526573756C742E6F732E76657273696F6E2C0A202020202020202020202020202022686173546F756368537570706F7274223A2061706578416E616C79746963732E686173546F756368537570706F727428292C0A20';
wwv_flow_api.g_varchar2_table(85) := '2020202020202020202020202022706167654C6F616454696D65223A2061706578416E616C79746963732E676574506167654C6F616454696D6528704576656E744E616D65292C0A20202020202020202020202020202273637265656E5769647468223A';
wwv_flow_api.g_varchar2_table(86) := '2061706578416E616C79746963732E67657453637265656E576964746828292C0A20202020202020202020202020202273637265656E486569676874223A2061706578416E616C79746963732E67657453637265656E48656967687428292C0A20202020';
wwv_flow_api.g_varchar2_table(87) := '2020202020202020202022617065784170704964223A202476282770466C6F77496427292C0A20202020202020202020202020202261706578506167654964223A202476282770466C6F7753746570496427292C0A202020202020202020202020202022';
wwv_flow_api.g_varchar2_table(88) := '6576656E744E616D65223A20704576656E744E616D652C0A2020202020202020202020202020226164646974696F6E616C496E666F223A20247628704164646974696F6E616C496E666F4974656D290A2020202020202020202020207D3B0A2020202020';
wwv_flow_api.g_varchar2_table(89) := '202020202020202F2F2062617365363420656E636F6465640A202020202020202020207D20656C7365207B0A202020202020202020202020656E636F646564537472696E67203D2070416E616C69746963734964202B20737472696E6744697669646572';
wwv_flow_api.g_varchar2_table(90) := '3B0A202020202020202020202020656E636F646564537472696E67202B3D20706172736572526573756C742E62726F777365722E6E616D65202B20737472696E67446976696465723B0A202020202020202020202020656E636F646564537472696E6720';
wwv_flow_api.g_varchar2_table(91) := '2B3D20706172736572526573756C742E62726F777365722E76657273696F6E202B20737472696E67446976696465723B0A202020202020202020202020656E636F646564537472696E67202B3D2061706578416E616C79746963732E67657442726F7773';
wwv_flow_api.g_varchar2_table(92) := '65724C616E67756167652829202B20737472696E67446976696465723B0A202020202020202020202020656E636F646564537472696E67202B3D20706172736572526573756C742E6F732E6E616D65202B20737472696E67446976696465723B0A202020';
wwv_flow_api.g_varchar2_table(93) := '202020202020202020656E636F646564537472696E67202B3D20706172736572526573756C742E6F732E76657273696F6E202B20737472696E67446976696465723B0A202020202020202020202020656E636F646564537472696E67202B3D2061706578';
wwv_flow_api.g_varchar2_table(94) := '416E616C79746963732E686173546F756368537570706F72742829202B20737472696E67446976696465723B0A202020202020202020202020656E636F646564537472696E67202B3D2061706578416E616C79746963732E676574506167654C6F616454';
wwv_flow_api.g_varchar2_table(95) := '696D6528704576656E744E616D6529202B20737472696E67446976696465723B0A202020202020202020202020656E636F646564537472696E67202B3D2061706578416E616C79746963732E67657453637265656E57696474682829202B20737472696E';
wwv_flow_api.g_varchar2_table(96) := '67446976696465723B0A202020202020202020202020656E636F646564537472696E67202B3D2061706578416E616C79746963732E67657453637265656E4865696768742829202B20737472696E67446976696465723B0A202020202020202020202020';
wwv_flow_api.g_varchar2_table(97) := '656E636F646564537472696E67202B3D202476282770466C6F7749642729202B20737472696E67446976696465723B0A202020202020202020202020656E636F646564537472696E67202B3D202476282770466C6F775374657049642729202B20737472';
wwv_flow_api.g_varchar2_table(98) := '696E67446976696465723B0A202020202020202020202020656E636F646564537472696E67202B3D20704576656E744E616D65202B20737472696E67446976696465723B0A202020202020202020202020656E636F646564537472696E67202B3D202476';
wwv_flow_api.g_varchar2_table(99) := '28704164646974696F6E616C496E666F4974656D293B0A202020202020202020202020616E616C79746963734A736F6E203D207B0A202020202020202020202020202022656E636F64655765627365727669636543616C6C223A2070456E636F64655765';
wwv_flow_api.g_varchar2_table(100) := '627365727669636543616C6C2C0A202020202020202020202020202022656E636F646564537472696E67223A2062746F6128656E636F646564537472696E67290A2020202020202020202020207D3B0A202020202020202020207D0A2020202020202020';
wwv_flow_api.g_varchar2_table(101) := '7D0A202020202020202072657475726E20616E616C79746963734A736F6E3B0A2020202020207D2C0A2020202020202F2A2A0A202020202020202A205265616C20506C7567696E2068616E646C6572202D2063616C6C65642066726F6D206F7574657220';
wwv_flow_api.g_varchar2_table(102) := '706C7567696E48616E646C65722066756E6374696F6E0A202020202020202A2040706172616D207B6F626A6563747D20704F7074696F6E730A202020202020202A2F0A202020202020706C7567696E48616E646C65723A2066756E6374696F6E28704F70';
wwv_flow_api.g_varchar2_table(103) := '74696F6E7329207B0A20202020202020202F2F20706C7567696E20617474726962757465730A202020202020202076617220616E616C79746963734964203D20704F7074696F6E732E616E616C797469637349643B0A2020202020202020766172206576';
wwv_flow_api.g_varchar2_table(104) := '656E744E616D65203D20704F7074696F6E732E6576656E744E616D653B0A0A202020202020202076617220616E616C79746963735265737455726C203D20704F7074696F6E732E616E616C79746963735265737455726C3B0A0A20202020202020207661';
wwv_flow_api.g_varchar2_table(105) := '72206164646974696F6E616C496E666F4974656D203D20704F7074696F6E732E6164646974696F6E616C496E666F4974656D3B0A202020202020202076617220656E636F64655765627365727669636543616C6C203D20704F7074696F6E732E656E636F';
wwv_flow_api.g_varchar2_table(106) := '64655765627365727669636543616C6C3B0A20202020202020207661722073746F704F6E4D61784572726F72203D20704F7074696F6E732E73746F704F6E4D61784572726F723B0A20202020202020207661722072657370656374446F4E6F7454726163';
wwv_flow_api.g_varchar2_table(107) := '6B203D20704F7074696F6E732E72657370656374446F4E6F74547261636B3B0A0A20202020202020202F2F2064656275670A2020202020202020617065782E64656275672E6C6F67282761706578416E616C79746963732E706C7567696E48616E646C65';
wwv_flow_api.g_varchar2_table(108) := '72202D20616E616C79746963734964272C20616E616C79746963734964293B0A2020202020202020617065782E64656275672E6C6F67282761706578416E616C79746963732E706C7567696E48616E646C6572202D206576656E744E616D65272C206576';
wwv_flow_api.g_varchar2_table(109) := '656E744E616D65293B0A0A2020202020202020617065782E64656275672E6C6F67282761706578416E616C79746963732E706C7567696E48616E646C6572202D20616E616C79746963735265737455726C272C20616E616C79746963735265737455726C';
wwv_flow_api.g_varchar2_table(110) := '293B0A0A2020202020202020617065782E64656275672E6C6F67282761706578416E616C79746963732E706C7567696E48616E646C6572202D206164646974696F6E616C496E666F4974656D272C206164646974696F6E616C496E666F4974656D293B0A';
wwv_flow_api.g_varchar2_table(111) := '2020202020202020617065782E64656275672E6C6F67282761706578416E616C79746963732E706C7567696E48616E646C6572202D20656E636F64655765627365727669636543616C6C272C20656E636F64655765627365727669636543616C6C293B0A';
wwv_flow_api.g_varchar2_table(112) := '2020202020202020617065782E64656275672E6C6F67282761706578416E616C79746963732E706C7567696E48616E646C6572202D2073746F704F6E4D61784572726F72272C2073746F704F6E4D61784572726F72293B0A202020202020202061706578';
wwv_flow_api.g_varchar2_table(113) := '2E64656275672E6C6F67282761706578416E616C79746963732E706C7567696E48616E646C6572202D2072657370656374446F4E6F74547261636B272C2072657370656374446F4E6F74547261636B293B0A0A20202020202020202F2F20636865636B20';
wwv_flow_api.g_varchar2_table(114) := '696620446F4E6F74547261636B206973206E6F74206163746976650A202020202020202069662028212861706578416E616C79746963732E6973446F4E6F74547261636B436F6D706C6574654163746976652872657370656374446F4E6F74547261636B';
wwv_flow_api.g_varchar2_table(115) := '292929207B0A202020202020202020202F2F2063616C6C20616E616C797469637320776562207365727669636520286F6E6C79206966206D6178206572726F7220636F756E74206973206E6F74206578636565646564290A202020202020202020206966';
wwv_flow_api.g_varchar2_table(116) := '202861706578416E616C79746963732E636865636B4572726F72436F756E742873746F704F6E4D61784572726F722929207B0A20202020202020202020202076617220616E616C797469637344617461203D2061706578416E616C79746963732E627569';
wwv_flow_api.g_varchar2_table(117) := '6C64416E616C79746963734A736F6E28616E616C797469637349642C206576656E744E616D652C206164646974696F6E616C496E666F4974656D2C20656E636F64655765627365727669636543616C6C293B0A2020202020202020202020202F2F206F6E';
wwv_flow_api.g_varchar2_table(118) := '6C792070726F6365737320696620616E616C7974696373204A534F4E20686173206265656E206275696C740A20202020202020202020202069662028616E616C79746963734461746129207B0A202020202020202020202020202061706578416E616C79';
wwv_flow_api.g_varchar2_table(119) := '746963732E63616C6C416E616C79746963735765627365727669636528616E616C79746963735265737455726C2C20616E616C7974696373446174612C2066756E6374696F6E286461746129207B0A202020202020202020202020202020202F2F207365';
wwv_flow_api.g_varchar2_table(120) := '74206572726F7220636F756E74657220696E2073657373696F6E2073746F726167652069662063616C6C206973206E6F74207375636365737366756C0A20202020202020202020202020202020696620282128646174612E737563636573732929207B0A';
wwv_flow_api.g_varchar2_table(121) := '20202020202020202020202020202020202061706578416E616C79746963732E7365744572726F72436F756E74557028293B0A202020202020202020202020202020207D0A20202020202020202020202020207D293B0A20202020202020202020202020';
wwv_flow_api.g_varchar2_table(122) := '202F2F206966206E6F20616E616C7974696373204A534F4E2063616E206265206275696C74202D2D3E20616C736F20736574206572726F7220636F756E7465722069732073657373696F6E2073746F726167650A2020202020202020202020207D20656C';
wwv_flow_api.g_varchar2_table(123) := '7365207B0A202020202020202020202020202061706578416E616C79746963732E7365744572726F72436F756E74557028293B0A2020202020202020202020207D0A202020202020202020207D0A20202020202020207D0A2020202020207D0A20202020';
wwv_flow_api.g_varchar2_table(124) := '7D3B202F2F20656E64206E616D6573706163652061706578416E616C79746963730A0A202020202F2F2063616C6C207265616C20706C7567696E48616E646C65722066756E6374696F6E0A20202020747279207B0A20202020202061706578416E616C79';
wwv_flow_api.g_varchar2_table(125) := '746963732E706C7567696E48616E646C657228704F7074696F6E73293B0A202020207D206361746368202865727229207B0A202020202020617065782E64656275672E6C6F67282761706578416E616C79746963732E706C7567696E48616E646C657220';
wwv_flow_api.g_varchar2_table(126) := '6572726F72272C20657272293B0A20202020202061706578416E616C79746963732E7365744572726F72436F756E74557028293B0A202020207D0A20207D0A7D3B0A';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(1765960092399095)
,p_plugin_id=>wwv_flow_api.id(6269942285913443)
,p_file_name=>'js/apexanalytics.js'
,p_mime_type=>'application/x-javascript'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '2166756E6374696F6E28692C73297B2275736520737472696374223B76617220653D226D6F64656C222C6F3D226E616D65222C723D2274797065222C6E3D2276656E646F72222C613D2276657273696F6E222C643D226D6F62696C65222C743D22746162';
wwv_flow_api.g_varchar2_table(2) := '6C6574222C6C3D7B657874656E643A66756E6374696F6E28692C73297B76617220653D7B7D3B666F7228766172206F20696E206929735B6F5D2626735B6F5D2E6C656E67746825323D3D303F655B6F5D3D735B6F5D2E636F6E63617428695B6F5D293A65';
wwv_flow_api.g_varchar2_table(3) := '5B6F5D3D695B6F5D3B72657475726E20657D2C6861733A66756E6374696F6E28692C73297B72657475726E22737472696E67223D3D747970656F66206926262D31213D3D732E746F4C6F7765724361736528292E696E6465784F6628692E746F4C6F7765';
wwv_flow_api.g_varchar2_table(4) := '72436173652829297D2C6C6F776572697A653A66756E6374696F6E2869297B72657475726E20692E746F4C6F7765724361736528297D2C6D616A6F723A66756E6374696F6E2869297B72657475726E22737472696E67223D3D747970656F6620693F692E';
wwv_flow_api.g_varchar2_table(5) := '7265706C616365282F5B5E5C645C2E5D2F672C2222292E73706C697428222E22295B305D3A766F696420307D2C7472696D3A66756E6374696F6E2869297B72657475726E20692E7265706C616365282F5E5B5C735C75464546465C7841305D2B7C5B5C73';
wwv_flow_api.g_varchar2_table(6) := '5C75464546465C7841305D2B242F672C2222297D7D2C773D7B7267783A66756E6374696F6E28692C73297B666F722876617220652C6F2C722C6E2C612C642C743D303B743C732E6C656E677468262621613B297B766172206C3D735B745D2C773D735B74';
wwv_flow_api.g_varchar2_table(7) := '2B315D3B666F7228653D6F3D303B653C6C2E6C656E677468262621613B29696628613D6C5B652B2B5D2E6578656328692929666F7228723D303B723C772E6C656E6774683B722B2B29643D615B2B2B6F5D2C226F626A656374223D3D747970656F66286E';
wwv_flow_api.g_varchar2_table(8) := '3D775B725D2926266E2E6C656E6774683E303F323D3D6E2E6C656E6774683F2266756E6374696F6E223D3D747970656F66206E5B315D3F746869735B6E5B305D5D3D6E5B315D2E63616C6C28746869732C64293A746869735B6E5B305D5D3D6E5B315D3A';
wwv_flow_api.g_varchar2_table(9) := '333D3D6E2E6C656E6774683F2266756E6374696F6E22213D747970656F66206E5B315D7C7C6E5B315D2E6578656326266E5B315D2E746573743F746869735B6E5B305D5D3D643F642E7265706C616365286E5B315D2C6E5B325D293A766F696420303A74';
wwv_flow_api.g_varchar2_table(10) := '6869735B6E5B305D5D3D643F6E5B315D2E63616C6C28746869732C642C6E5B325D293A766F696420303A343D3D6E2E6C656E677468262628746869735B6E5B305D5D3D643F6E5B335D2E63616C6C28746869732C642E7265706C616365286E5B315D2C6E';
wwv_flow_api.g_varchar2_table(11) := '5B325D29293A766F69642030293A746869735B6E5D3D647C7C766F696420303B742B3D327D7D2C7374723A66756E6374696F6E28692C73297B666F7228766172206520696E207329696628226F626A656374223D3D747970656F6620735B655D2626735B';
wwv_flow_api.g_varchar2_table(12) := '655D2E6C656E6774683E30297B666F7228766172206F3D303B6F3C735B655D2E6C656E6774683B6F2B2B296966286C2E68617328735B655D5B6F5D2C69292972657475726E223F223D3D3D653F766F696420303A657D656C7365206966286C2E68617328';
wwv_flow_api.g_varchar2_table(13) := '735B655D2C69292972657475726E223F223D3D3D653F766F696420303A653B72657475726E20697D7D2C753D7B62726F777365723A7B6F6C647361666172693A7B76657273696F6E3A7B22312E30223A222F38222C312E323A222F31222C312E333A222F';
wwv_flow_api.g_varchar2_table(14) := '33222C22322E30223A222F343132222C22322E302E32223A222F343136222C22322E302E33223A222F343137222C22322E302E34223A222F343139222C223F223A222F227D7D7D2C6465766963653A7B616D617A6F6E3A7B6D6F64656C3A7B2246697265';
wwv_flow_api.g_varchar2_table(15) := '2050686F6E65223A5B225344222C224B46225D7D7D2C737072696E743A7B6D6F64656C3A7B2245766F205368696674203447223A22373337334B54227D2C76656E646F723A7B4854433A22415041222C537072696E743A22537072696E74227D7D7D2C6F';
wwv_flow_api.g_varchar2_table(16) := '733A7B77696E646F77733A7B76657273696F6E3A7B4D453A22342E3930222C224E5420332E3131223A224E54332E3531222C224E5420342E30223A224E54342E30222C323030303A224E5420352E30222C58503A5B224E5420352E31222C224E5420352E';
wwv_flow_api.g_varchar2_table(17) := '32225D2C56697374613A224E5420362E30222C373A224E5420362E31222C383A224E5420362E32222C382E313A224E5420362E33222C31303A5B224E5420362E34222C224E542031302E30225D2C52543A2241524D227D7D7D7D2C633D7B62726F777365';
wwv_flow_api.g_varchar2_table(18) := '723A5B5B2F286F706572615C736D696E69295C2F285B5C775C2E2D5D2B292F692C2F286F706572615C735B6D6F62696C657461625D2B292E2B76657273696F6E5C2F285B5C775C2E2D5D2B292F692C2F286F70657261292E2B76657273696F6E5C2F285B';
wwv_flow_api.g_varchar2_table(19) := '5C775C2E5D2B292F692C2F286F70657261295B5C2F5C735D2B285B5C775C2E5D2B292F695D2C5B6F2C615D2C5B2F286F70696F73295B5C2F5C735D2B285B5C775C2E5D2B292F695D2C5B5B6F2C224F70657261204D696E69225D2C615D2C5B2F5C73286F';
wwv_flow_api.g_varchar2_table(20) := '7072295C2F285B5C775C2E5D2B292F695D2C5B5B6F2C224F70657261225D2C615D2C5B2F286B696E646C65295C2F285B5C775C2E5D2B292F692C2F286C756E6173636170657C6D617874686F6E7C6E657466726F6E747C6A61736D696E657C626C617A65';
wwv_flow_api.g_varchar2_table(21) := '72295B5C2F5C735D3F285B5C775C2E5D2A292F692C2F286176616E745C737C69656D6F62696C657C736C696D7C626169647529283F3A62726F77736572293F5B5C2F5C735D3F285B5C775C2E5D2A292F692C2F283F3A6D737C5C2829286965295C73285B';
wwv_flow_api.g_varchar2_table(22) := '5C775C2E5D2B292F692C2F2872656B6F6E71295C2F285B5C775C2E5D2A292F692C2F286368726F6D69756D7C666C6F636B7C726F636B6D656C747C6D69646F72697C6570697068616E797C73696C6B7C736B79666972657C6F766962726F777365727C62';
wwv_flow_api.g_varchar2_table(23) := '6F6C747C69726F6E7C766976616C64697C6972696469756D7C7068616E746F6D6A737C626F777365727C717561726B295C2F285B5C775C2E2D5D2B292F695D2C5B6F2C615D2C5B2F2874726964656E74292E2B72765B3A5C735D285B5C775C2E5D2B292E';
wwv_flow_api.g_varchar2_table(24) := '2B6C696B655C736765636B6F2F695D2C5B5B6F2C224945225D2C615D2C5B2F28656467657C656467696F737C65646761295C2F28285C642B293F5B5C775C2E5D2B292F695D2C5B5B6F2C2245646765225D2C615D2C5B2F28796162726F77736572295C2F';
wwv_flow_api.g_varchar2_table(25) := '285B5C775C2E5D2B292F695D2C5B5B6F2C2259616E646578225D2C615D2C5B2F2870756666696E295C2F285B5C775C2E5D2B292F695D2C5B5B6F2C2250756666696E225D2C615D2C5B2F28666F637573295C2F285B5C775C2E5D2B292F695D2C5B5B6F2C';
wwv_flow_api.g_varchar2_table(26) := '2246697265666F7820466F637573225D2C615D2C5B2F286F7074295C2F285B5C775C2E5D2B292F695D2C5B5B6F2C224F7065726120546F756368225D2C615D2C5B2F28283F3A5B5C735C2F5D2975633F5C733F62726F777365727C283F3A6A75632E2B29';
wwv_flow_api.g_varchar2_table(27) := '7563776562295B5C2F5C735D3F285B5C775C2E5D2B292F695D2C5B5B6F2C22554342726F77736572225D2C615D2C5B2F28636F6D6F646F5F647261676F6E295C2F285B5C775C2E5D2B292F695D2C5B5B6F2C2F5F2F672C2220225D2C615D2C5B2F286D69';
wwv_flow_api.g_varchar2_table(28) := '63726F6D657373656E676572295C2F285B5C775C2E5D2B292F695D2C5B5B6F2C22576543686174225D2C615D2C5B2F286272617665295C2F285B5C775C2E5D2B292F695D2C5B5B6F2C224272617665225D2C615D2C5B2F28717162726F777365726C6974';
wwv_flow_api.g_varchar2_table(29) := '65295C2F285B5C775C2E5D2B292F695D2C5B6F2C615D2C5B2F285151295C2F285B5C645C2E5D2B292F695D2C5B6F2C615D2C5B2F6D3F28717162726F77736572295B5C2F5C735D3F285B5C775C2E5D2B292F695D2C5B6F2C615D2C5B2F28424944554272';
wwv_flow_api.g_varchar2_table(30) := '6F77736572295B5C2F5C735D3F285B5C775C2E5D2B292F695D2C5B6F2C615D2C5B2F28323334354578706C6F726572295B5C2F5C735D3F285B5C775C2E5D2B292F695D2C5B6F2C615D2C5B2F284D6574615372295B5C2F5C735D3F285B5C775C2E5D2B29';
wwv_flow_api.g_varchar2_table(31) := '2F695D2C5B6F5D2C5B2F284C4242524F57534552292F695D2C5B6F5D2C5B2F7869616F6D695C2F6D69756962726F777365725C2F285B5C775C2E5D2B292F695D2C5B612C5B6F2C224D4955492042726F77736572225D5D2C5B2F3B666261765C2F285B5C';
wwv_flow_api.g_varchar2_table(32) := '775C2E5D2B293B2F695D2C5B612C5B6F2C2246616365626F6F6B225D5D2C5B2F7361666172695C73286C696E65295C2F285B5C775C2E5D2B292F692C2F616E64726F69642E2B286C696E65295C2F285B5C775C2E5D2B295C2F6961622F695D2C5B6F2C61';
wwv_flow_api.g_varchar2_table(33) := '5D2C5B2F686561646C6573736368726F6D65283F3A5C2F285B5C775C2E5D2B297C5C73292F695D2C5B612C5B6F2C224368726F6D6520486561646C657373225D5D2C5B2F5C7377765C292E2B286368726F6D65295C2F285B5C775C2E5D2B292F695D2C5B';
wwv_flow_api.g_varchar2_table(34) := '5B6F2C2F282E2B292F2C2224312057656256696577225D2C615D2C5B2F28283F3A6F63756C75737C73616D73756E672962726F77736572295C2F285B5C775C2E5D2B292F695D2C5B5B6F2C2F282E2B283F3A677C75732929282E2B292F2C222431202432';
wwv_flow_api.g_varchar2_table(35) := '225D2C615D2C5B2F616E64726F69642E2B76657273696F6E5C2F285B5C775C2E5D2B295C732B283F3A6D6F62696C655C733F7361666172697C736166617269292A2F695D2C5B612C5B6F2C22416E64726F69642042726F77736572225D5D2C5B2F286368';
wwv_flow_api.g_varchar2_table(36) := '726F6D657C6F6D6E697765627C61726F72617C5B74697A656E6F6B615D7B357D5C733F62726F77736572295C2F763F285B5C775C2E5D2B292F695D2C5B6F2C615D2C5B2F28646F6C66696E295C2F285B5C775C2E5D2B292F695D2C5B5B6F2C22446F6C70';
wwv_flow_api.g_varchar2_table(37) := '68696E225D2C615D2C5B2F28283F3A616E64726F69642E2B2963726D6F7C6372696F73295C2F285B5C775C2E5D2B292F695D2C5B5B6F2C224368726F6D65225D2C615D2C5B2F28636F617374295C2F285B5C775C2E5D2B292F695D2C5B5B6F2C224F7065';
wwv_flow_api.g_varchar2_table(38) := '726120436F617374225D2C615D2C5B2F6678696F735C2F285B5C775C2E2D5D2B292F695D2C5B612C5B6F2C2246697265666F78225D5D2C5B2F76657273696F6E5C2F285B5C775C2E5D2B292E2B3F6D6F62696C655C2F5C772B5C7328736166617269292F';
wwv_flow_api.g_varchar2_table(39) := '695D2C5B612C5B6F2C224D6F62696C6520536166617269225D5D2C5B2F76657273696F6E5C2F285B5C775C2E5D2B292E2B3F286D6F62696C655C733F7361666172697C736166617269292F695D2C5B612C6F5D2C5B2F7765626B69742E2B3F2867736129';
wwv_flow_api.g_varchar2_table(40) := '5C2F285B5C775C2E5D2B292E2B3F286D6F62696C655C733F7361666172697C73616661726929285C2F5B5C775C2E5D2B292F695D2C5B5B6F2C22475341225D2C615D2C5B2F7765626B69742E2B3F286D6F62696C655C733F7361666172697C7361666172';
wwv_flow_api.g_varchar2_table(41) := '6929285C2F5B5C775C2E5D2B292F695D2C5B6F2C5B612C772E7374722C752E62726F777365722E6F6C647361666172692E76657273696F6E5D5D2C5B2F286B6F6E717565726F72295C2F285B5C775C2E5D2B292F692C2F287765626B69747C6B68746D6C';
wwv_flow_api.g_varchar2_table(42) := '295C2F285B5C775C2E5D2B292F695D2C5B6F2C615D2C5B2F286E6176696761746F727C6E65747363617065295C2F285B5C775C2E2D5D2B292F695D2C5B5B6F2C224E65747363617065225D2C615D2C5B2F287377696674666F78292F692C2F2869636564';
wwv_flow_api.g_varchar2_table(43) := '7261676F6E7C69636577656173656C7C63616D696E6F7C6368696D6572617C66656E6E65637C6D61656D6F5C7362726F777365727C6D696E696D6F7C636F6E6B65726F72295B5C2F5C735D3F285B5C775C2E5C2B5D2B292F692C2F2866697265666F787C';
wwv_flow_api.g_varchar2_table(44) := '7365616D6F6E6B65797C6B2D6D656C656F6E7C6963656361747C6963656170657C66697265626972647C70686F656E69787C70616C656D6F6F6E7C626173696C69736B7C7761746572666F78295C2F285B5C775C2E2D5D2B29242F692C2F286D6F7A696C';
wwv_flow_api.g_varchar2_table(45) := '6C61295C2F285B5C775C2E5D2B292E2B72765C3A2E2B6765636B6F5C2F5C642B2F692C2F28706F6C617269737C6C796E787C64696C6C6F7C696361627C646F7269737C616D6179617C77336D7C6E6574737572667C736C6569706E6972295B5C2F5C735D';
wwv_flow_api.g_varchar2_table(46) := '3F285B5C775C2E5D2B292F692C2F286C696E6B73295C735C28285B5C775C2E5D2B292F692C2F28676F62726F77736572295C2F3F285B5C775C2E5D2A292F692C2F286963655C733F62726F77736572295C2F763F285B5C775C2E5F5D2B292F692C2F286D';
wwv_flow_api.g_varchar2_table(47) := '6F73616963295B5C2F5C735D285B5C775C2E5D2B292F695D2C5B6F2C615D5D2C6370753A5B5B2F283F3A28616D647C78283F3A283F3A38367C3634295B5F2D5D293F7C776F777C77696E293634295B3B5C295D2F695D2C5B5B2261726368697465637475';
wwv_flow_api.g_varchar2_table(48) := '7265222C22616D643634225D5D2C5B2F2869613332283F3D3B29292F695D2C5B5B22617263686974656374757265222C6C2E6C6F776572697A655D5D2C5B2F28283F3A695B3334365D7C78293836295B3B5C295D2F695D2C5B5B22617263686974656374';
wwv_flow_api.g_varchar2_table(49) := '757265222C2269613332225D5D2C5B2F77696E646F77735C732863657C6D6F62696C65293B5C737070633B2F695D2C5B5B22617263686974656374757265222C2261726D225D5D2C5B2F28283F3A7070637C706F776572706329283F3A3634293F29283F';
wwv_flow_api.g_varchar2_table(50) := '3A5C736D61637C3B7C5C29292F695D2C5B5B22617263686974656374757265222C2F6F7765722F2C22222C6C2E6C6F776572697A655D5D2C5B2F2873756E345C77295B3B5C295D2F695D2C5B5B22617263686974656374757265222C227370617263225D';
wwv_flow_api.g_varchar2_table(51) := '5D2C5B2F28283F3A61767233327C69613634283F3D3B29297C36386B283F3D5C29297C61726D283F3A36347C283F3D765C642B5B3B6C5D29297C283F3D61746D656C5C73296176727C283F3A697269787C6D6970737C737061726329283F3A3634293F28';
wwv_flow_api.g_varchar2_table(52) := '3F3D3B297C70612D72697363292F695D2C5B5B22617263686974656374757265222C6C2E6C6F776572697A655D5D5D2C6465766963653A5B5B2F5C2828697061647C706C6179626F6F6B293B5B5C775C735C293B2D5D2B2872696D7C6170706C65292F69';
wwv_flow_api.g_varchar2_table(53) := '5D2C5B652C6E2C5B722C745D5D2C5B2F6170706C65636F72656D656469615C2F5B5C775C2E5D2B205C282869706164292F5D2C5B652C5B6E2C224170706C65225D2C5B722C745D5D2C5B2F286170706C655C737B302C317D7476292F695D2C5B5B652C22';
wwv_flow_api.g_varchar2_table(54) := '4170706C65205456225D2C5B6E2C224170706C65225D5D2C5B2F28617263686F73295C732867616D65706164323F292F692C2F286870292E2B28746F756368706164292F692C2F286870292E2B287461626C6574292F692C2F286B696E646C65295C2F28';
wwv_flow_api.g_varchar2_table(55) := '5B5C775C2E5D2B292F692C2F5C73286E6F6F6B295B5C775C735D2B6275696C645C2F285C772B292F692C2F2864656C6C295C732873747265615B6B70725C735C645D2A5B5C646B6F5D292F695D2C5B6E2C652C5B722C745D5D2C5B2F286B665B412D7A5D';
wwv_flow_api.g_varchar2_table(56) := '2B295C736275696C645C2F2E2B73696C6B5C2F2F695D2C5B652C5B6E2C22416D617A6F6E225D2C5B722C745D5D2C5B2F2873647C6B66295B3033343968696A6F72737475775D2B5C736275696C645C2F2E2B73696C6B5C2F2F695D2C5B5B652C772E7374';
wwv_flow_api.g_varchar2_table(57) := '722C752E6465766963652E616D617A6F6E2E6D6F64656C5D2C5B6E2C22416D617A6F6E225D2C5B722C645D5D2C5B2F616E64726F69642E2B616674285B626D735D295C736275696C642F695D2C5B652C5B6E2C22416D617A6F6E225D2C5B722C22736D61';
wwv_flow_api.g_varchar2_table(58) := '72747476225D5D2C5B2F5C282869705B686F6E65647C5C735C772A5D2B293B2E2B286170706C65292F695D2C5B652C6E2C5B722C645D5D2C5B2F5C282869705B686F6E65647C5C735C772A5D2B293B2F695D2C5B652C5B6E2C224170706C65225D2C5B72';
wwv_flow_api.g_varchar2_table(59) := '2C645D5D2C5B2F28626C61636B6265727279295B5C732D5D3F285C772B292F692C2F28626C61636B62657272797C62656E717C70616C6D283F3D5C2D297C736F6E796572696373736F6E7C616365727C617375737C64656C6C7C6D65697A757C6D6F746F';
wwv_flow_api.g_varchar2_table(60) := '726F6C617C706F6C7974726F6E295B5C735F2D5D3F285B5C772D5D2A292F692C2F286870295C73285B5C775C735D2B5C77292F692C2F2861737573292D3F285C772B292F695D2C5B6E2C652C5B722C645D5D2C5B2F5C28626231303B5C73285C772B292F';
wwv_flow_api.g_varchar2_table(61) := '695D2C5B652C5B6E2C22426C61636B4265727279225D2C5B722C645D5D2C5B2F616E64726F69642E2B287472616E73666F5B7072696D655C735D7B342C31307D5C735C772B7C65656570637C736C696465725C735C772B7C6E6578757320377C70616466';
wwv_flow_api.g_varchar2_table(62) := '6F6E65292F695D2C5B652C5B6E2C2241737573225D2C5B722C745D5D2C5B2F28736F6E79295C73287461626C65745C735B70735D295C736275696C645C2F2F692C2F28736F6E79293F283F3A7367702E2B295C736275696C645C2F2F695D2C5B5B6E2C22';
wwv_flow_api.g_varchar2_table(63) := '536F6E79225D2C5B652C22587065726961205461626C6574225D2C5B722C745D5D2C5B2F616E64726F69642E2B5C73285B632D675D5C647B347D7C736F5B2D6C5D5C772B295C736275696C645C2F2F695D2C5B652C5B6E2C22536F6E79225D2C5B722C64';
wwv_flow_api.g_varchar2_table(64) := '5D5D2C5B2F5C73286F757961295C732F692C2F286E696E74656E646F295C73285B7769647333755D2B292F695D2C5B6E2C652C5B722C22636F6E736F6C65225D5D2C5B2F616E64726F69642E2B3B5C7328736869656C64295C736275696C642F695D2C5B';
wwv_flow_api.g_varchar2_table(65) := '652C5B6E2C224E7669646961225D2C5B722C22636F6E736F6C65225D5D2C5B2F28706C617973746174696F6E5C735B3334706F727461626C6576695D2B292F695D2C5B652C5B6E2C22536F6E79225D2C5B722C22636F6E736F6C65225D5D2C5B2F287370';
wwv_flow_api.g_varchar2_table(66) := '72696E745C73285C772B29292F695D2C5B5B6E2C772E7374722C752E6465766963652E737072696E742E76656E646F725D2C5B652C772E7374722C752E6465766963652E737072696E742E6D6F64656C5D2C5B722C645D5D2C5B2F286C656E6F766F295C';
wwv_flow_api.g_varchar2_table(67) := '733F2853283F3A353030307C36303030292B283F3A5B2D5D5B5C772B5D29292F695D2C5B6E2C652C5B722C745D5D2C5B2F28687463295B3B5F5C732D5D2B285B5C775C735D2B283F3D5C29297C5C772B292A2F692C2F287A7465292D285C772A292F692C';
wwv_flow_api.g_varchar2_table(68) := '2F28616C636174656C7C6765656B7370686F6E657C6C656E6F766F7C6E657869616E7C70616E61736F6E69637C283F3D3B5C7329736F6E79295B5F5C732D5D3F285B5C772D5D2A292F695D2C5B6E2C5B652C2F5F2F672C2220225D2C5B722C645D5D2C5B';
wwv_flow_api.g_varchar2_table(69) := '2F286E657875735C7339292F695D2C5B652C5B6E2C22485443225D2C5B722C745D5D2C5B2F645C2F687561776569285B5C775C732D5D2B295B3B5C295D2F692C2F286E657875735C733670292F695D2C5B652C5B6E2C22487561776569225D2C5B722C64';
wwv_flow_api.g_varchar2_table(70) := '5D5D2C5B2F286D6963726F736F6674293B5C73286C756D69615B5C735C775D2B292F695D2C5B6E2C652C5B722C645D5D2C5B2F5B5C735C283B5D2878626F78283F3A5C736F6E65293F295B5C735C293B5D2F695D2C5B652C5B6E2C224D6963726F736F66';
wwv_flow_api.g_varchar2_table(71) := '74225D2C5B722C22636F6E736F6C65225D5D2C5B2F286B696E5C2E5B6F6E6574775D7B337D292F695D2C5B5B652C2F5C2E2F672C2220225D2C5B6E2C224D6963726F736F6674225D2C5B722C645D5D2C5B2F5C73286D696C6573746F6E657C64726F6964';
wwv_flow_api.g_varchar2_table(72) := '283F3A5B322D34785D7C5C73283F3A62696F6E69637C78327C70726F7C72617A7229293F3A3F285C733467293F295B5C775C735D2B6275696C645C2F2F692C2F6D6F745B5C732D5D3F285C772A292F692C2F2858545C647B332C347D29206275696C645C';
wwv_flow_api.g_varchar2_table(73) := '2F2F692C2F286E657875735C7336292F695D2C5B652C5B6E2C224D6F746F726F6C61225D2C5B722C645D5D2C5B2F616E64726F69642E2B5C73286D7A36305C647C786F6F6D5B5C73325D7B302C327D295C736275696C645C2F2F695D2C5B652C5B6E2C22';
wwv_flow_api.g_varchar2_table(74) := '4D6F746F726F6C61225D2C5B722C745D5D2C5B2F68626274765C2F5C642B5C2E5C642B5C2E5C642B5C732B5C285B5C775C735D2A3B5C732A285C775B5E3B5D2A293B285B5E3B5D2A292F695D2C5B5B6E2C6C2E7472696D5D2C5B652C6C2E7472696D5D2C';
wwv_flow_api.g_varchar2_table(75) := '5B722C22736D6172747476225D5D2C5B2F68626274762E2B6D61706C653B285C642B292F695D2C5B5B652C2F5E2F2C22536D6172745456225D2C5B6E2C2253616D73756E67225D2C5B722C22736D6172747476225D5D2C5B2F5C286474765B5C293B5D2E';
wwv_flow_api.g_varchar2_table(76) := '2B286171756F73292F695D2C5B652C5B6E2C225368617270225D2C5B722C22736D6172747476225D5D2C5B2F616E64726F69642E2B28287363682D695B38395D305C647C7368772D6D333830737C67742D705C647B347D7C67742D6E5C642B7C7367682D';
wwv_flow_api.g_varchar2_table(77) := '74385B35365D397C6E6578757320313029292F692C2F2828534D2D545C772B29292F695D2C5B5B6E2C2253616D73756E67225D2C652C5B722C745D5D2C5B2F736D6172742D74762E2B2873616D73756E67292F695D2C5B6E2C5B722C22736D6172747476';
wwv_flow_api.g_varchar2_table(78) := '225D2C655D2C5B2F2828735B6367705D682D5C772B7C67742D5C772B7C67616C6178795C736E657875737C736D2D5C775B5C775C645D2B29292F692C2F2873616D5B73756E675D2A295B5C732D5D2A285C772B2D3F5B5C772D5D2A292F692C2F7365632D';
wwv_flow_api.g_varchar2_table(79) := '28287367685C772B29292F695D2C5B5B6E2C2253616D73756E67225D2C652C5B722C645D5D2C5B2F7369652D285C772A292F695D2C5B652C5B6E2C225369656D656E73225D2C5B722C645D5D2C5B2F286D61656D6F7C6E6F6B6961292E2A286E3930307C';
wwv_flow_api.g_varchar2_table(80) := '6C756D69615C735C642B292F692C2F286E6F6B6961295B5C735F2D5D3F285B5C772D5D2A292F695D2C5B5B6E2C224E6F6B6961225D2C652C5B722C645D5D2C5B2F616E64726F69645C73335C2E5B5C735C773B2D5D7B31307D28615C647B337D292F695D';
wwv_flow_api.g_varchar2_table(81) := '2C5B652C5B6E2C2241636572225D2C5B722C745D5D2C5B2F616E64726F69642E2B285B766C5D6B5C2D3F5C647B337D295C732B6275696C642F695D2C5B652C5B6E2C224C47225D2C5B722C745D5D2C5B2F616E64726F69645C73335C2E5B5C735C773B2D';
wwv_flow_api.g_varchar2_table(82) := '5D7B31307D286C673F292D285B30366376395D7B332C347D292F695D2C5B5B6E2C224C47225D2C652C5B722C745D5D2C5B2F286C6729206E6574636173745C2E74762F695D2C5B6E2C652C5B722C22736D6172747476225D5D2C5B2F286E657875735C73';
wwv_flow_api.g_varchar2_table(83) := '5B34355D292F692C2F6C675B653B5C735C2F2D5D2B285C772A292F692C2F616E64726F69642E2B6C67285C2D3F5B5C645C775D2B295C732B6275696C642F695D2C5B652C5B6E2C224C47225D2C5B722C645D5D2C5B2F616E64726F69642E2B2869646561';
wwv_flow_api.g_varchar2_table(84) := '7461625B612D7A302D395C2D5C735D2B292F695D2C5B652C5B6E2C224C656E6F766F225D2C5B722C745D5D2C5B2F6C696E75783B2E2B28286A6F6C6C6129293B2F695D2C5B6E2C652C5B722C645D5D2C5B2F2828706562626C6529296170705C2F5B5C64';
wwv_flow_api.g_varchar2_table(85) := '5C2E5D2B5C732F695D2C5B6E2C652C5B722C227765617261626C65225D5D2C5B2F616E64726F69642E2B3B5C73286F70706F295C733F285B5C775C735D2B295C736275696C642F695D2C5B6E2C652C5B722C645D5D2C5B2F63726B65792F695D2C5B5B65';
wwv_flow_api.g_varchar2_table(86) := '2C224368726F6D6563617374225D2C5B6E2C22476F6F676C65225D5D2C5B2F616E64726F69642E2B3B5C7328676C617373295C735C642F695D2C5B652C5B6E2C22476F6F676C65225D2C5B722C227765617261626C65225D5D2C5B2F616E64726F69642E';
wwv_flow_api.g_varchar2_table(87) := '2B3B5C7328706978656C2063295B5C73295D2F695D2C5B652C5B6E2C22476F6F676C65225D2C5B722C745D5D2C5B2F616E64726F69642E2B3B5C7328706978656C28205B32335D293F2820786C293F295C732F695D2C5B652C5B6E2C22476F6F676C6522';
wwv_flow_api.g_varchar2_table(88) := '5D2C5B722C645D5D2C5B2F616E64726F69642E2B3B5C73285C772B295C732B6275696C645C2F686D5C312F692C2F616E64726F69642E2B28686D5B5C735C2D5F5D2A6E6F74653F5B5C735F5D2A283F3A5C645C77293F295C732B6275696C642F692C2F61';
wwv_flow_api.g_varchar2_table(89) := '6E64726F69642E2B286D695B5C735C2D5F5D2A283F3A6F6E657C6F6E655B5C735F5D706C75737C6E6F7465206C7465293F5B5C735F5D2A283F3A5C643F5C773F295B5C735F5D2A283F3A706C7573293F295C732B6275696C642F692C2F616E64726F6964';
wwv_flow_api.g_varchar2_table(90) := '2E2B287265646D695B5C735C2D5F5D2A283F3A6E6F7465293F283F3A5B5C735F5D2A5B5C775C735D2B29295C732B6275696C642F695D2C5B5B652C2F5F2F672C2220225D2C5B6E2C225869616F6D69225D2C5B722C645D5D2C5B2F616E64726F69642E2B';
wwv_flow_api.g_varchar2_table(91) := '286D695B5C735C2D5F5D2A283F3A70616429283F3A5B5C735F5D2A5B5C775C735D2B29295C732B6275696C642F695D2C5B5B652C2F5F2F672C2220225D2C5B6E2C225869616F6D69225D2C5B722C745D5D2C5B2F616E64726F69642E2B3B5C73286D5B31';
wwv_flow_api.g_varchar2_table(92) := '2D355D5C736E6F7465295C736275696C642F695D2C5B652C5B6E2C224D65697A75225D2C5B722C745D5D2C5B2F286D7A292D285B5C772D5D7B322C7D292F695D2C5B5B6E2C224D65697A75225D2C652C5B722C645D5D2C5B2F616E64726F69642E2B6130';
wwv_flow_api.g_varchar2_table(93) := '30302831295C732B6275696C642F692C2F616E64726F69642E2B6F6E65706C75735C7328615C647B347D295C732B6275696C642F695D2C5B652C5B6E2C224F6E65506C7573225D2C5B722C645D5D2C5B2F616E64726F69642E2B5B3B5C2F5D5C732A2852';
wwv_flow_api.g_varchar2_table(94) := '43545B5C645C775D2B295C732B6275696C642F695D2C5B652C5B6E2C22524341225D2C5B722C745D5D2C5B2F616E64726F69642E2B5B3B5C2F5C735D2B2856656E75655B5C645C735D7B322C377D295C732B6275696C642F695D2C5B652C5B6E2C224465';
wwv_flow_api.g_varchar2_table(95) := '6C6C225D2C5B722C745D5D2C5B2F616E64726F69642E2B5B3B5C2F5D5C732A28515B547C4D5D5B5C645C775D2B295C732B6275696C642F695D2C5B652C5B6E2C22566572697A6F6E225D2C5B722C745D5D2C5B2F616E64726F69642E2B5B3B5C2F5D5C73';
wwv_flow_api.g_varchar2_table(96) := '2B284261726E65735B265C735D2B4E6F626C655C732B7C424E5B52545D2928563F2E2A295C732B6275696C642F695D2C5B5B6E2C224261726E65732026204E6F626C65225D2C652C5B722C745D5D2C5B2F616E64726F69642E2B5B3B5C2F5D5C732B2854';
wwv_flow_api.g_varchar2_table(97) := '4D5C647B337D2E2A5C62295C732B6275696C642F695D2C5B652C5B6E2C224E75566973696F6E225D2C5B722C745D5D2C5B2F616E64726F69642E2B3B5C73286B3838295C736275696C642F695D2C5B652C5B6E2C225A5445225D2C5B722C745D5D2C5B2F';
wwv_flow_api.g_varchar2_table(98) := '616E64726F69642E2B5B3B5C2F5D5C732A2867656E5C647B337D295C732B6275696C642E2A3439682F695D2C5B652C5B6E2C225377697373225D2C5B722C645D5D2C5B2F616E64726F69642E2B5B3B5C2F5D5C732A287A75725C647B337D295C732B6275';
wwv_flow_api.g_varchar2_table(99) := '696C642F695D2C5B652C5B6E2C225377697373225D2C5B722C745D5D2C5B2F616E64726F69642E2B5B3B5C2F5D5C732A28285A656B69293F54422E2A5C62295C732B6275696C642F695D2C5B652C5B6E2C225A656B69225D2C5B722C745D5D2C5B2F2861';
wwv_flow_api.g_varchar2_table(100) := '6E64726F6964292E2B5B3B5C2F5D5C732B285B59525D5C647B327D295C732B6275696C642F692C2F616E64726F69642E2B5B3B5C2F5D5C732B28447261676F6E5B5C2D5C735D2B546F7563685C732B7C445429285C777B357D295C736275696C642F695D';
wwv_flow_api.g_varchar2_table(101) := '2C5B5B6E2C22447261676F6E20546F756368225D2C652C5B722C745D5D2C5B2F616E64726F69642E2B5B3B5C2F5D5C732A284E532D3F5C777B302C397D295C736275696C642F695D2C5B652C5B6E2C22496E7369676E6961225D2C5B722C745D5D2C5B2F';
wwv_flow_api.g_varchar2_table(102) := '616E64726F69642E2B5B3B5C2F5D5C732A28284E587C4E657874292D3F5C777B302C397D295C732B6275696C642F695D2C5B652C5B6E2C224E657874426F6F6B225D2C5B722C745D5D2C5B2F616E64726F69642E2B5B3B5C2F5D5C732A28587472656D65';
wwv_flow_api.g_varchar2_table(103) := '5C5F293F285628315B3034355D7C325B3031355D7C33307C34307C36307C375B30355D7C393029295C732B6275696C642F695D2C5B5B6E2C22566F696365225D2C652C5B722C645D5D2C5B2F616E64726F69642E2B5B3B5C2F5D5C732A284C5654454C5C';
wwv_flow_api.g_varchar2_table(104) := '2D293F2856315B31325D295C732B6275696C642F695D2C5B5B6E2C224C7654656C225D2C652C5B722C645D5D2C5B2F616E64726F69642E2B3B5C732850482D31295C732F695D2C5B652C5B6E2C22457373656E7469616C225D2C5B722C645D5D2C5B2F61';
wwv_flow_api.g_varchar2_table(105) := '6E64726F69642E2B5B3B5C2F5D5C732A2856283130304D447C3730304E417C373031317C39313747292E2A5C62295C732B6275696C642F695D2C5B652C5B6E2C22456E76697A656E225D2C5B722C745D5D2C5B2F616E64726F69642E2B5B3B5C2F5D5C73';
wwv_flow_api.g_varchar2_table(106) := '2A284C655B5C735C2D5D2B50616E295B5C735C2D5D2B285C777B312C397D295C732B6275696C642F695D2C5B6E2C652C5B722C745D5D2C5B2F616E64726F69642E2B5B3B5C2F5D5C732A285472696F5B5C735C2D5D2A2E2A295C732B6275696C642F695D';
wwv_flow_api.g_varchar2_table(107) := '2C5B652C5B6E2C224D6163685370656564225D2C5B722C745D5D2C5B2F616E64726F69642E2B5B3B5C2F5D5C732A285472696E697479295B5C2D5C735D2A28545C647B337D295C732B6275696C642F695D2C5B6E2C652C5B722C745D5D2C5B2F616E6472';
wwv_flow_api.g_varchar2_table(108) := '6F69642E2B5B3B5C2F5D5C732A54555F2831343931295C732B6275696C642F695D2C5B652C5B6E2C22526F746F72225D2C5B722C745D5D2C5B2F616E64726F69642E2B284B53282E2B29295C732B6275696C642F695D2C5B652C5B6E2C22416D617A6F6E';
wwv_flow_api.g_varchar2_table(109) := '225D2C5B722C745D5D2C5B2F616E64726F69642E2B2847696761736574295B5C735C2D5D2B28515C777B312C397D295C732B6275696C642F695D2C5B6E2C652C5B722C745D5D2C5B2F5C73287461626C65747C746162295B3B5C2F5D2F692C2F5C73286D';
wwv_flow_api.g_varchar2_table(110) := '6F62696C6529283F3A5B3B5C2F5D7C5C73736166617269292F695D2C5B5B722C6C2E6C6F776572697A655D2C6E2C655D2C5B2F28616E64726F69645B5C775C2E5C735C2D5D7B302C397D293B2E2B6275696C642F695D2C5B652C5B6E2C2247656E657269';
wwv_flow_api.g_varchar2_table(111) := '63225D5D5D2C656E67696E653A5B5B2F77696E646F77732E2B5C73656467655C2F285B5C775C2E5D2B292F695D2C5B612C5B6F2C224564676548544D4C225D5D2C5B2F2870726573746F295C2F285B5C775C2E5D2B292F692C2F287765626B69747C7472';
wwv_flow_api.g_varchar2_table(112) := '6964656E747C6E657466726F6E747C6E6574737572667C616D6179617C6C796E787C77336D295C2F285B5C775C2E5D2B292F692C2F286B68746D6C7C7461736D616E7C6C696E6B73295B5C2F5C735D5C283F285B5C775C2E5D2B292F692C2F2869636162';
wwv_flow_api.g_varchar2_table(113) := '295B5C2F5C735D285B32335D5C2E5B5C645C2E5D2B292F695D2C5B6F2C615D2C5B2F72765C3A285B5C775C2E5D7B312C397D292E2B286765636B6F292F695D2C5B612C6F5D5D2C6F733A5B5B2F6D6963726F736F66745C732877696E646F7773295C7328';
wwv_flow_api.g_varchar2_table(114) := '76697374617C7870292F695D2C5B6F2C615D2C5B2F2877696E646F7773295C736E745C73365C2E323B5C732861726D292F692C2F2877696E646F77735C7370686F6E65283F3A5C736F73292A295B5C735C2F5D3F285B5C645C2E5C735C775D2A292F692C';
wwv_flow_api.g_varchar2_table(115) := '2F2877696E646F77735C736D6F62696C657C77696E646F7773295B5C735C2F5D3F285B6E7463655C645C2E5C735D2B5C77292F695D2C5B6F2C5B612C772E7374722C752E6F732E77696E646F77732E76657273696F6E5D5D2C5B2F2877696E283F3D337C';
wwv_flow_api.g_varchar2_table(116) := '397C6E297C77696E5C7339785C7329285B6E745C645C2E5D2B292F695D2C5B5B6F2C2257696E646F7773225D2C5B612C772E7374722C752E6F732E77696E646F77732E76657273696F6E5D5D2C5B2F5C2828626229283130293B2F695D2C5B5B6F2C2242';
wwv_flow_api.g_varchar2_table(117) := '6C61636B4265727279225D2C615D2C5B2F28626C61636B6265727279295C772A5C2F3F285B5C775C2E5D2A292F692C2F2874697A656E295B5C2F5C735D285B5C775C2E5D2B292F692C2F28616E64726F69647C7765626F737C70616C6D5C736F737C716E';
wwv_flow_api.g_varchar2_table(118) := '787C626164617C72696D5C737461626C65745C736F737C6D6565676F7C636F6E74696B69295B5C2F5C732D5D3F285B5C775C2E5D2A292F692C2F6C696E75783B2E2B287361696C66697368293B2F695D2C5B6F2C615D2C5B2F2873796D6269616E5C733F';
wwv_flow_api.g_varchar2_table(119) := '6F737C73796D626F737C733630283F3D3B29295B5C2F5C732D5D3F285B5C775C2E5D2A292F695D2C5B5B6F2C2253796D6269616E225D2C615D2C5B2F5C28287365726965733430293B2F695D2C5B6F5D2C5B2F6D6F7A696C6C612E2B5C286D6F62696C65';
wwv_flow_api.g_varchar2_table(120) := '3B2E2B6765636B6F2E2B66697265666F782F695D2C5B5B6F2C2246697265666F78204F53225D2C615D2C5B2F286E696E74656E646F7C706C617973746174696F6E295C73285B776964733334706F727461626C6576755D2B292F692C2F286D696E74295B';
wwv_flow_api.g_varchar2_table(121) := '5C2F5C735C285D3F285C772A292F692C2F286D61676569617C766563746F726C696E7578295B3B5C735D2F692C2F286A6F6C697C5B6B786C6E5D3F7562756E74757C64656269616E7C737573657C6F70656E737573657C67656E746F6F7C283F3D5C7329';
wwv_flow_api.g_varchar2_table(122) := '617263687C736C61636B776172657C6665646F72617C6D616E64726976617C63656E746F737C70636C696E75786F737C7265646861747C7A656E77616C6B7C6C696E707573295B5C2F5C732D5D3F283F216368726F6D29285B5C775C2E2D5D2A292F692C';
wwv_flow_api.g_varchar2_table(123) := '2F28687572647C6C696E7578295C733F285B5C775C2E5D2A292F692C2F28676E75295C733F285B5C775C2E5D2A292F695D2C5B6F2C615D2C5B2F2863726F73295C735B5C775D2B5C73285B5C775C2E5D2B5C77292F695D2C5B5B6F2C224368726F6D6975';
wwv_flow_api.g_varchar2_table(124) := '6D204F53225D2C615D2C5B2F2873756E6F73295C733F285B5C775C2E5C645D2A292F695D2C5B5B6F2C22536F6C61726973225D2C615D2C5B2F5C73285B6672656E746F70632D5D7B302C347D6273647C647261676F6E666C79295C733F285B5C775C2E5D';
wwv_flow_api.g_varchar2_table(125) := '2A292F695D2C5B6F2C615D2C5B2F286861696B75295C73285C772B292F695D2C5B6F2C615D2C5B2F63666E6574776F726B5C2F2E2B64617277696E2F692C2F69705B686F6E6561645D7B322C347D283F3A2E2A6F735C73285B5C775D2B295C736C696B65';
wwv_flow_api.g_varchar2_table(126) := '5C736D61637C3B5C736F70657261292F695D2C5B5B612C2F5F2F672C222E225D2C5B6F2C22694F53225D5D2C5B2F286D61635C736F735C7378295C733F285B5C775C735C2E5D2A292F692C2F286D6163696E746F73687C6D6163283F3D5F706F77657270';
wwv_flow_api.g_varchar2_table(127) := '63295C73292F695D2C5B5B6F2C224D6163204F53225D2C5B612C2F5F2F672C222E225D5D2C5B2F28283F3A6F70656E293F736F6C61726973295B5C2F5C732D5D3F285B5C775C2E5D2A292F692C2F28616978295C7328285C6429283F3D5C2E7C5C297C5C';
wwv_flow_api.g_varchar2_table(128) := '73295B5C775C2E5D292A2F692C2F28706C616E5C73397C6D696E69787C62656F737C6F735C2F327C616D6967616F737C6D6F7270686F737C726973635C736F737C6F70656E766D737C66756368736961292F692C2F28756E6978295C733F285B5C775C2E';
wwv_flow_api.g_varchar2_table(129) := '5D2A292F695D2C5B6F2C615D5D7D2C6D3D66756E6374696F6E28732C65297B696628226F626A656374223D3D747970656F662073262628653D732C733D766F69642030292C21287468697320696E7374616E63656F66206D292972657475726E206E6577';
wwv_flow_api.g_varchar2_table(130) := '206D28732C65292E676574526573756C7428293B766172206F3D737C7C28692626692E6E6176696761746F722626692E6E6176696761746F722E757365724167656E743F692E6E6176696761746F722E757365724167656E743A2222292C723D653F6C2E';
wwv_flow_api.g_varchar2_table(131) := '657874656E6428632C65293A633B72657475726E20746869732E67657442726F777365723D66756E6374696F6E28297B76617220693D7B6E616D653A766F696420302C76657273696F6E3A766F696420307D3B72657475726E20772E7267782E63616C6C';
wwv_flow_api.g_varchar2_table(132) := '28692C6F2C722E62726F77736572292C692E6D616A6F723D6C2E6D616A6F7228692E76657273696F6E292C697D2C746869732E6765744350553D66756E6374696F6E28297B76617220693D7B6172636869746563747572653A766F696420307D3B726574';
wwv_flow_api.g_varchar2_table(133) := '75726E20772E7267782E63616C6C28692C6F2C722E637075292C697D2C746869732E6765744465766963653D66756E6374696F6E28297B76617220693D7B76656E646F723A766F696420302C6D6F64656C3A766F696420302C747970653A766F69642030';
wwv_flow_api.g_varchar2_table(134) := '7D3B72657475726E20772E7267782E63616C6C28692C6F2C722E646576696365292C697D2C746869732E676574456E67696E653D66756E6374696F6E28297B76617220693D7B6E616D653A766F696420302C76657273696F6E3A766F696420307D3B7265';
wwv_flow_api.g_varchar2_table(135) := '7475726E20772E7267782E63616C6C28692C6F2C722E656E67696E65292C697D2C746869732E6765744F533D66756E6374696F6E28297B76617220693D7B6E616D653A766F696420302C76657273696F6E3A766F696420307D3B72657475726E20772E72';
wwv_flow_api.g_varchar2_table(136) := '67782E63616C6C28692C6F2C722E6F73292C697D2C746869732E676574526573756C743D66756E6374696F6E28297B72657475726E7B75613A746869732E676574554128292C62726F777365723A746869732E67657442726F7773657228292C656E6769';
wwv_flow_api.g_varchar2_table(137) := '6E653A746869732E676574456E67696E6528292C6F733A746869732E6765744F5328292C6465766963653A746869732E67657444657669636528292C6370753A746869732E67657443505528297D7D2C746869732E67657455413D66756E6374696F6E28';
wwv_flow_api.g_varchar2_table(138) := '297B72657475726E206F7D2C746869732E73657455413D66756E6374696F6E2869297B72657475726E206F3D692C746869737D2C746869737D3B6D2E56455253494F4E3D22302E372E3139222C6D2E42524F575345523D7B4E414D453A6F2C4D414A4F52';
wwv_flow_api.g_varchar2_table(139) := '3A226D616A6F72222C56455253494F4E3A617D2C6D2E4350553D7B4152434849544543545552453A22617263686974656374757265227D2C6D2E4445564943453D7B4D4F44454C3A652C56454E444F523A6E2C545950453A722C434F4E534F4C453A2263';
wwv_flow_api.g_varchar2_table(140) := '6F6E736F6C65222C4D4F42494C453A642C534D41525454563A22736D6172747476222C5441424C45543A742C5745415241424C453A227765617261626C65222C454D4245444445443A22656D626564646564227D2C6D2E454E47494E453D7B4E414D453A';
wwv_flow_api.g_varchar2_table(141) := '6F2C56455253494F4E3A617D2C6D2E4F533D7B4E414D453A6F2C56455253494F4E3A617D2C22756E646566696E656422213D747970656F66206578706F7274733F2822756E646566696E656422213D747970656F66206D6F64756C6526266D6F64756C65';
wwv_flow_api.g_varchar2_table(142) := '2E6578706F7274732626286578706F7274733D6D6F64756C652E6578706F7274733D6D292C6578706F7274732E55415061727365723D6D293A2266756E6374696F6E223D3D747970656F6620646566696E652626646566696E652E616D643F646566696E';
wwv_flow_api.g_varchar2_table(143) := '652866756E6374696F6E28297B72657475726E206D7D293A69262628692E55415061727365723D6D293B76617220623D69262628692E6A51756572797C7C692E5A6570746F293B696628766F69642030213D3D62262621622E7561297B76617220703D6E';
wwv_flow_api.g_varchar2_table(144) := '6577206D3B622E75613D702E676574526573756C7428292C622E75612E6765743D66756E6374696F6E28297B72657475726E20702E676574554128297D2C622E75612E7365743D66756E6374696F6E2869297B702E73657455412869293B76617220733D';
wwv_flow_api.g_varchar2_table(145) := '702E676574526573756C7428293B666F7228766172206520696E207329622E75615B655D3D735B655D7D7D7D28226F626A656374223D3D747970656F662077696E646F773F77696E646F773A74686973293B';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(2763487151619110)
,p_plugin_id=>wwv_flow_api.id(6269942285913443)
,p_file_name=>'js/uap.min.js'
,p_mime_type=>'application/x-javascript'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '2F2A210A202A2055415061727365722E6A732076302E372E31390A202A204C69676874776569676874204A6176615363726970742D626173656420557365722D4167656E7420737472696E67207061727365720A202A2068747470733A2F2F6769746875';
wwv_flow_api.g_varchar2_table(2) := '622E636F6D2F66616973616C6D616E2F75612D7061727365722D6A730A202A0A202A20436F7079726967687420C2A920323031322D323031362046616973616C2053616C6D616E203C66797A6C6D616E40676D61696C2E636F6D3E0A202A204475616C20';
wwv_flow_api.g_varchar2_table(3) := '6C6963656E73656420756E6465722047504C7632206F72204D49540A202A2F0A0A2866756E6374696F6E202877696E646F772C20756E646566696E656429207B0A0A202020202775736520737472696374273B0A0A202020202F2F2F2F2F2F2F2F2F2F2F';
wwv_flow_api.g_varchar2_table(4) := '2F2F2F0A202020202F2F20436F6E7374616E74730A202020202F2F2F2F2F2F2F2F2F2F2F2F2F0A0A0A20202020766172204C494256455253494F4E20203D2027302E372E3139272C0A2020202020202020454D505459202020202020203D2027272C0A20';
wwv_flow_api.g_varchar2_table(5) := '20202020202020554E4B4E4F574E20202020203D20273F272C0A202020202020202046554E435F545950452020203D202766756E6374696F6E272C0A2020202020202020554E4445465F5459504520203D2027756E646566696E6564272C0A2020202020';
wwv_flow_api.g_varchar2_table(6) := '2020204F424A5F54595045202020203D20276F626A656374272C0A20202020202020205354525F54595045202020203D2027737472696E67272C0A20202020202020204D414A4F52202020202020203D20276D616A6F72272C202F2F2064657072656361';
wwv_flow_api.g_varchar2_table(7) := '7465640A20202020202020204D4F44454C202020202020203D20276D6F64656C272C0A20202020202020204E414D4520202020202020203D20276E616D65272C0A20202020202020205459504520202020202020203D202774797065272C0A2020202020';
wwv_flow_api.g_varchar2_table(8) := '20202056454E444F522020202020203D202776656E646F72272C0A202020202020202056455253494F4E20202020203D202776657273696F6E272C0A20202020202020204152434849544543545552453D2027617263686974656374757265272C0A2020';
wwv_flow_api.g_varchar2_table(9) := '202020202020434F4E534F4C4520202020203D2027636F6E736F6C65272C0A20202020202020204D4F42494C452020202020203D20276D6F62696C65272C0A20202020202020205441424C45542020202020203D20277461626C6574272C0A2020202020';
wwv_flow_api.g_varchar2_table(10) := '202020534D415254545620202020203D2027736D6172747476272C0A20202020202020205745415241424C45202020203D20277765617261626C65272C0A2020202020202020454D424544444544202020203D2027656D626564646564273B0A0A0A2020';
wwv_flow_api.g_varchar2_table(11) := '20202F2F2F2F2F2F2F2F2F2F2F0A202020202F2F2048656C7065720A202020202F2F2F2F2F2F2F2F2F2F0A0A0A20202020766172207574696C203D207B0A2020202020202020657874656E64203A2066756E6374696F6E2028726567657865732C206578';
wwv_flow_api.g_varchar2_table(12) := '74656E73696F6E7329207B0A202020202020202020202020766172206D617267656452656765786573203D207B7D3B0A202020202020202020202020666F722028766172206920696E207265676578657329207B0A202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(13) := '2069662028657874656E73696F6E735B695D20262620657874656E73696F6E735B695D2E6C656E67746820252032203D3D3D203029207B0A20202020202020202020202020202020202020206D6172676564526567657865735B695D203D20657874656E';
wwv_flow_api.g_varchar2_table(14) := '73696F6E735B695D2E636F6E63617428726567657865735B695D293B0A202020202020202020202020202020207D20656C7365207B0A20202020202020202020202020202020202020206D6172676564526567657865735B695D203D2072656765786573';
wwv_flow_api.g_varchar2_table(15) := '5B695D3B0A202020202020202020202020202020207D0A2020202020202020202020207D0A20202020202020202020202072657475726E206D6172676564526567657865733B0A20202020202020207D2C0A2020202020202020686173203A2066756E63';
wwv_flow_api.g_varchar2_table(16) := '74696F6E2028737472312C207374723229207B0A2020202020202020202069662028747970656F662073747231203D3D3D2022737472696E672229207B0A20202020202020202020202072657475726E20737472322E746F4C6F7765724361736528292E';
wwv_flow_api.g_varchar2_table(17) := '696E6465784F6628737472312E746F4C6F7765724361736528292920213D3D202D313B0A202020202020202020207D20656C7365207B0A20202020202020202020202072657475726E2066616C73653B0A202020202020202020207D0A20202020202020';
wwv_flow_api.g_varchar2_table(18) := '207D2C0A20202020202020206C6F776572697A65203A2066756E6374696F6E202873747229207B0A20202020202020202020202072657475726E207374722E746F4C6F7765724361736528293B0A20202020202020207D2C0A20202020202020206D616A';
wwv_flow_api.g_varchar2_table(19) := '6F72203A2066756E6374696F6E202876657273696F6E29207B0A20202020202020202020202072657475726E20747970656F662876657273696F6E29203D3D3D205354525F54595045203F2076657273696F6E2E7265706C616365282F5B5E5C645C2E5D';
wwv_flow_api.g_varchar2_table(20) := '2F672C2727292E73706C697428222E22295B305D203A20756E646566696E65643B0A20202020202020207D2C0A20202020202020207472696D203A2066756E6374696F6E202873747229207B0A2020202020202020202072657475726E207374722E7265';
wwv_flow_api.g_varchar2_table(21) := '706C616365282F5E5B5C735C75464546465C7841305D2B7C5B5C735C75464546465C7841305D2B242F672C202727293B0A20202020202020207D0A202020207D3B0A0A0A202020202F2F2F2F2F2F2F2F2F2F2F2F2F2F2F0A202020202F2F204D61702068';
wwv_flow_api.g_varchar2_table(22) := '656C7065720A202020202F2F2F2F2F2F2F2F2F2F2F2F2F2F0A0A0A20202020766172206D6170706572203D207B0A0A2020202020202020726778203A2066756E6374696F6E202875612C2061727261797329207B0A0A2020202020202020202020202F2F';
wwv_flow_api.g_varchar2_table(23) := '76617220726573756C74203D207B7D2C0A2020202020202020202020207661722069203D20302C206A2C206B2C20702C20712C206D6174636865732C206D617463683B2F2F2C2061726773203D20617267756D656E74733B0A0A20202020202020202020';
wwv_flow_api.g_varchar2_table(24) := '20202F2A2F2F20636F6E737472756374206F626A6563742062617265626F6E65730A202020202020202020202020666F72202870203D20303B2070203C20617267735B315D2E6C656E6774683B20702B2B29207B0A202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(25) := '2071203D20617267735B315D5B705D3B0A20202020202020202020202020202020726573756C745B747970656F662071203D3D3D204F424A5F54595045203F20715B305D203A20715D203D20756E646566696E65643B0A2020202020202020202020207D';
wwv_flow_api.g_varchar2_table(26) := '2A2F0A0A2020202020202020202020202F2F206C6F6F70207468726F75676820616C6C2072656765786573206D6170730A2020202020202020202020207768696C65202869203C206172726179732E6C656E67746820262620216D61746368657329207B';
wwv_flow_api.g_varchar2_table(27) := '0A0A20202020202020202020202020202020766172207265676578203D206172726179735B695D2C202020202020202F2F206576656E2073657175656E63652028302C322C342C2E2E290A202020202020202020202020202020202020202070726F7073';
wwv_flow_api.g_varchar2_table(28) := '203D206172726179735B69202B20315D3B2020202F2F206F64642073657175656E63652028312C332C352C2E2E290A202020202020202020202020202020206A203D206B203D20303B0A0A202020202020202020202020202020202F2F20747279206D61';
wwv_flow_api.g_varchar2_table(29) := '746368696E67207561737472696E67207769746820726567657865730A202020202020202020202020202020207768696C6520286A203C2072656765782E6C656E67746820262620216D61746368657329207B0A0A202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(30) := '20202020206D617463686573203D2072656765785B6A2B2B5D2E65786563287561293B0A0A20202020202020202020202020202020202020206966202821216D61746368657329207B0A202020202020202020202020202020202020202020202020666F';
wwv_flow_api.g_varchar2_table(31) := '72202870203D20303B2070203C2070726F70732E6C656E6774683B20702B2B29207B0A202020202020202020202020202020202020202020202020202020206D61746368203D206D6174636865735B2B2B6B5D3B0A202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(32) := '2020202020202020202020202071203D2070726F70735B705D3B0A202020202020202020202020202020202020202020202020202020202F2F20636865636B20696620676976656E2070726F70657274792069732061637475616C6C792061727261790A';
wwv_flow_api.g_varchar2_table(33) := '2020202020202020202020202020202020202020202020202020202069662028747970656F662071203D3D3D204F424A5F5459504520262620712E6C656E677468203E203029207B0A202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(34) := '202020202069662028712E6C656E677468203D3D203229207B0A20202020202020202020202020202020202020202020202020202020202020202020202069662028747970656F6620715B315D203D3D2046554E435F5459504529207B0A202020202020';
wwv_flow_api.g_varchar2_table(35) := '202020202020202020202020202020202020202020202020202020202020202020202F2F2061737369676E206D6F646966696564206D617463680A2020202020202020202020202020202020202020202020202020202020202020202020202020202074';
wwv_flow_api.g_varchar2_table(36) := '6869735B715B305D5D203D20715B315D2E63616C6C28746869732C206D61746368293B0A2020202020202020202020202020202020202020202020202020202020202020202020207D20656C7365207B0A20202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(37) := '2020202020202020202020202020202020202020202F2F2061737369676E20676976656E2076616C75652C2069676E6F7265207265676578206D617463680A20202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(38) := '202020746869735B715B305D5D203D20715B315D3B0A2020202020202020202020202020202020202020202020202020202020202020202020207D0A20202020202020202020202020202020202020202020202020202020202020207D20656C73652069';
wwv_flow_api.g_varchar2_table(39) := '662028712E6C656E677468203D3D203329207B0A2020202020202020202020202020202020202020202020202020202020202020202020202F2F20636865636B20776865746865722066756E6374696F6E206F722072656765780A202020202020202020';
wwv_flow_api.g_varchar2_table(40) := '20202020202020202020202020202020202020202020202020202069662028747970656F6620715B315D203D3D3D2046554E435F54595045202626202128715B315D2E6578656320262620715B315D2E746573742929207B0A2020202020202020202020';
wwv_flow_api.g_varchar2_table(41) := '20202020202020202020202020202020202020202020202020202020202F2F2063616C6C2066756E6374696F6E2028757375616C6C7920737472696E67206D6170706572290A202020202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(42) := '20202020202020202020746869735B715B305D5D203D206D61746368203F20715B315D2E63616C6C28746869732C206D617463682C20715B325D29203A20756E646566696E65643B0A202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(43) := '2020202020202020207D20656C7365207B0A202020202020202020202020202020202020202020202020202020202020202020202020202020202F2F2073616E6974697A65206D61746368207573696E6720676976656E2072656765780A202020202020';
wwv_flow_api.g_varchar2_table(44) := '20202020202020202020202020202020202020202020202020202020202020202020746869735B715B305D5D203D206D61746368203F206D617463682E7265706C61636528715B315D2C20715B325D29203A20756E646566696E65643B0A202020202020';
wwv_flow_api.g_varchar2_table(45) := '2020202020202020202020202020202020202020202020202020202020207D0A20202020202020202020202020202020202020202020202020202020202020207D20656C73652069662028712E6C656E677468203D3D203429207B0A2020202020202020';
wwv_flow_api.g_varchar2_table(46) := '2020202020202020202020202020202020202020202020202020202020202020746869735B715B305D5D203D206D61746368203F20715B335D2E63616C6C28746869732C206D617463682E7265706C61636528715B315D2C20715B325D2929203A20756E';
wwv_flow_api.g_varchar2_table(47) := '646566696E65643B0A20202020202020202020202020202020202020202020202020202020202020207D0A202020202020202020202020202020202020202020202020202020207D20656C7365207B0A2020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(48) := '202020202020202020202020746869735B715D203D206D61746368203F206D61746368203A20756E646566696E65643B0A202020202020202020202020202020202020202020202020202020207D0A202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(49) := '2020207D0A20202020202020202020202020202020202020207D0A202020202020202020202020202020207D0A2020202020202020202020202020202069202B3D20323B0A2020202020202020202020207D0A2020202020202020202020202F2F20636F';
wwv_flow_api.g_varchar2_table(50) := '6E736F6C652E6C6F672874686973293B0A2020202020202020202020202F2F72657475726E20746869733B0A20202020202020207D2C0A0A2020202020202020737472203A2066756E6374696F6E20287374722C206D617029207B0A0A20202020202020';
wwv_flow_api.g_varchar2_table(51) := '2020202020666F722028766172206920696E206D617029207B0A202020202020202020202020202020202F2F20636865636B2069662061727261790A2020202020202020202020202020202069662028747970656F66206D61705B695D203D3D3D204F42';
wwv_flow_api.g_varchar2_table(52) := '4A5F54595045202626206D61705B695D2E6C656E677468203E203029207B0A2020202020202020202020202020202020202020666F722028766172206A203D20303B206A203C206D61705B695D2E6C656E6774683B206A2B2B29207B0A20202020202020';
wwv_flow_api.g_varchar2_table(53) := '2020202020202020202020202020202020696620287574696C2E686173286D61705B695D5B6A5D2C207374722929207B0A2020202020202020202020202020202020202020202020202020202072657475726E202869203D3D3D20554E4B4E4F574E2920';
wwv_flow_api.g_varchar2_table(54) := '3F20756E646566696E6564203A20693B0A2020202020202020202020202020202020202020202020207D0A20202020202020202020202020202020202020207D0A202020202020202020202020202020207D20656C736520696620287574696C2E686173';
wwv_flow_api.g_varchar2_table(55) := '286D61705B695D2C207374722929207B0A202020202020202020202020202020202020202072657475726E202869203D3D3D20554E4B4E4F574E29203F20756E646566696E6564203A20693B0A202020202020202020202020202020207D0A2020202020';
wwv_flow_api.g_varchar2_table(56) := '202020202020207D0A20202020202020202020202072657475726E207374723B0A20202020202020207D0A202020207D3B0A0A0A202020202F2F2F2F2F2F2F2F2F2F2F2F2F2F2F0A202020202F2F20537472696E67206D61700A202020202F2F2F2F2F2F';
wwv_flow_api.g_varchar2_table(57) := '2F2F2F2F2F2F2F2F0A0A0A20202020766172206D617073203D207B0A0A202020202020202062726F77736572203A207B0A2020202020202020202020206F6C64736166617269203A207B0A2020202020202020202020202020202076657273696F6E203A';
wwv_flow_api.g_varchar2_table(58) := '207B0A202020202020202020202020202020202020202027312E30272020203A20272F38272C0A202020202020202020202020202020202020202027312E32272020203A20272F31272C0A202020202020202020202020202020202020202027312E3327';
wwv_flow_api.g_varchar2_table(59) := '2020203A20272F33272C0A202020202020202020202020202020202020202027322E30272020203A20272F343132272C0A202020202020202020202020202020202020202027322E302E3227203A20272F343136272C0A20202020202020202020202020';
wwv_flow_api.g_varchar2_table(60) := '2020202020202027322E302E3327203A20272F343137272C0A202020202020202020202020202020202020202027322E302E3427203A20272F343139272C0A2020202020202020202020202020202020202020273F2720202020203A20272F270A202020';
wwv_flow_api.g_varchar2_table(61) := '202020202020202020202020207D0A2020202020202020202020207D0A20202020202020207D2C0A0A2020202020202020646576696365203A207B0A202020202020202020202020616D617A6F6E203A207B0A202020202020202020202020202020206D';
wwv_flow_api.g_varchar2_table(62) := '6F64656C203A207B0A202020202020202020202020202020202020202027466972652050686F6E6527203A205B275344272C20274B46275D0A202020202020202020202020202020207D0A2020202020202020202020207D2C0A20202020202020202020';
wwv_flow_api.g_varchar2_table(63) := '2020737072696E74203A207B0A202020202020202020202020202020206D6F64656C203A207B0A20202020202020202020202020202020202020202745766F20536869667420344727203A2027373337334B54270A202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(64) := '207D2C0A2020202020202020202020202020202076656E646F72203A207B0A20202020202020202020202020202020202020202748544327202020202020203A2027415041272C0A202020202020202020202020202020202020202027537072696E7427';
wwv_flow_api.g_varchar2_table(65) := '202020203A2027537072696E74270A202020202020202020202020202020207D0A2020202020202020202020207D0A20202020202020207D2C0A0A20202020202020206F73203A207B0A20202020202020202020202077696E646F7773203A207B0A2020';
wwv_flow_api.g_varchar2_table(66) := '202020202020202020202020202076657273696F6E203A207B0A2020202020202020202020202020202020202020274D452720202020202020203A2027342E3930272C0A2020202020202020202020202020202020202020274E5420332E313127202020';
wwv_flow_api.g_varchar2_table(67) := '3A20274E54332E3531272C0A2020202020202020202020202020202020202020274E5420342E3027202020203A20274E54342E30272C0A20202020202020202020202020202020202020202732303030272020202020203A20274E5420352E30272C0A20';
wwv_flow_api.g_varchar2_table(68) := '202020202020202020202020202020202020202758502720202020202020203A205B274E5420352E31272C20274E5420352E32275D2C0A20202020202020202020202020202020202020202756697374612720202020203A20274E5420362E30272C0A20';
wwv_flow_api.g_varchar2_table(69) := '202020202020202020202020202020202020202737272020202020202020203A20274E5420362E31272C0A20202020202020202020202020202020202020202738272020202020202020203A20274E5420362E32272C0A20202020202020202020202020';
wwv_flow_api.g_varchar2_table(70) := '2020202020202027382E3127202020202020203A20274E5420362E33272C0A20202020202020202020202020202020202020202731302720202020202020203A205B274E5420362E34272C20274E542031302E30275D2C0A202020202020202020202020';
wwv_flow_api.g_varchar2_table(71) := '20202020202020202752542720202020202020203A202741524D270A202020202020202020202020202020207D0A2020202020202020202020207D0A20202020202020207D0A202020207D3B0A0A0A202020202F2F2F2F2F2F2F2F2F2F2F2F2F2F0A2020';
wwv_flow_api.g_varchar2_table(72) := '20202F2F205265676578206D61700A202020202F2F2F2F2F2F2F2F2F2F2F2F2F0A0A0A202020207661722072656765786573203D207B0A0A202020202020202062726F77736572203A205B5B0A0A2020202020202020202020202F2F2050726573746F20';
wwv_flow_api.g_varchar2_table(73) := '62617365640A2020202020202020202020202F286F706572615C736D696E69295C2F285B5C775C2E2D5D2B292F692C2020202020202020202020202020202020202020202020202020202020202020202020202020202F2F204F70657261204D696E690A';
wwv_flow_api.g_varchar2_table(74) := '2020202020202020202020202F286F706572615C735B6D6F62696C657461625D2B292E2B76657273696F6E5C2F285B5C775C2E2D5D2B292F692C202020202020202020202020202020202020202020202F2F204F70657261204D6F62692F5461626C6574';
wwv_flow_api.g_varchar2_table(75) := '0A2020202020202020202020202F286F70657261292E2B76657273696F6E5C2F285B5C775C2E5D2B292F692C202020202020202020202020202020202020202020202020202020202020202020202020202F2F204F70657261203E20392E38300A202020';
wwv_flow_api.g_varchar2_table(76) := '2020202020202020202F286F70657261295B5C2F5C735D2B285B5C775C2E5D2B292F692020202020202020202020202020202020202020202020202020202020202020202020202020202020202F2F204F70657261203C20392E38300A20202020202020';
wwv_flow_api.g_varchar2_table(77) := '20202020205D2C205B4E414D452C2056455253494F4E5D2C205B0A0A2020202020202020202020202F286F70696F73295B5C2F5C735D2B285B5C775C2E5D2B292F6920202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(78) := '20202020202020202F2F204F70657261206D696E69206F6E206970686F6E65203E3D20382E300A2020202020202020202020205D2C205B5B4E414D452C20274F70657261204D696E69275D2C2056455253494F4E5D2C205B0A0A20202020202020202020';
wwv_flow_api.g_varchar2_table(79) := '20202F5C73286F7072295C2F285B5C775C2E5D2B292F6920202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202F2F204F70657261205765626B69740A2020202020202020202020205D2C';
wwv_flow_api.g_varchar2_table(80) := '205B5B4E414D452C20274F70657261275D2C2056455253494F4E5D2C205B0A0A2020202020202020202020202F2F204D697865640A2020202020202020202020202F286B696E646C65295C2F285B5C775C2E5D2B292F692C202020202020202020202020';
wwv_flow_api.g_varchar2_table(81) := '2020202020202020202020202020202020202020202020202020202020202020202F2F204B696E646C650A2020202020202020202020202F286C756E6173636170657C6D617874686F6E7C6E657466726F6E747C6A61736D696E657C626C617A6572295B';
wwv_flow_api.g_varchar2_table(82) := '5C2F5C735D3F285B5C775C2E5D2A292F692C0A20202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202F';
wwv_flow_api.g_varchar2_table(83) := '2F204C756E6173636170652F4D617874686F6E2F4E657466726F6E742F4A61736D696E652F426C617A65720A0A2020202020202020202020202F2F2054726964656E742062617365640A2020202020202020202020202F286176616E745C737C69656D6F';
wwv_flow_api.g_varchar2_table(84) := '62696C657C736C696D7C626169647529283F3A62726F77736572293F5B5C2F5C735D3F285B5C775C2E5D2A292F692C0A20202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(85) := '202020202020202020202020202020202020202020202020202020202F2F204176616E742F49454D6F62696C652F536C696D42726F777365722F42616964750A2020202020202020202020202F283F3A6D737C5C2829286965295C73285B5C775C2E5D2B';
wwv_flow_api.g_varchar2_table(86) := '292F692C202020202020202020202020202020202020202020202020202020202020202020202020202020202F2F20496E7465726E6574204578706C6F7265720A0A2020202020202020202020202F2F205765626B69742F4B48544D4C2062617365640A';
wwv_flow_api.g_varchar2_table(87) := '2020202020202020202020202F2872656B6F6E71295C2F285B5C775C2E5D2A292F692C2020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202F2F2052656B6F6E710A20202020202020202020';
wwv_flow_api.g_varchar2_table(88) := '20202F286368726F6D69756D7C666C6F636B7C726F636B6D656C747C6D69646F72697C6570697068616E797C73696C6B7C736B79666972657C6F766962726F777365727C626F6C747C69726F6E7C766976616C64697C6972696469756D7C7068616E746F';
wwv_flow_api.g_varchar2_table(89) := '6D6A737C626F777365727C717561726B295C2F285B5C775C2E2D5D2B292F690A2020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(90) := '2020202020202020202020202F2F204368726F6D69756D2F466C6F636B2F526F636B4D656C742F4D69646F72692F4570697068616E792F53696C6B2F536B79666972652F426F6C742F49726F6E2F4972696469756D2F5068616E746F6D4A532F426F7773';
wwv_flow_api.g_varchar2_table(91) := '65720A2020202020202020202020205D2C205B4E414D452C2056455253494F4E5D2C205B0A0A2020202020202020202020202F2874726964656E74292E2B72765B3A5C735D285B5C775C2E5D2B292E2B6C696B655C736765636B6F2F6920202020202020';
wwv_flow_api.g_varchar2_table(92) := '2020202020202020202020202020202020202F2F20494531310A2020202020202020202020205D2C205B5B4E414D452C20274945275D2C2056455253494F4E5D2C205B0A0A2020202020202020202020202F28656467657C656467696F737C6564676129';
wwv_flow_api.g_varchar2_table(93) := '5C2F28285C642B293F5B5C775C2E5D2B292F692020202020202020202020202020202020202020202020202020202020202F2F204D6963726F736F667420456467650A2020202020202020202020205D2C205B5B4E414D452C202745646765275D2C2056';
wwv_flow_api.g_varchar2_table(94) := '455253494F4E5D2C205B0A0A2020202020202020202020202F28796162726F77736572295C2F285B5C775C2E5D2B292F69202020202020202020202020202020202020202020202020202020202020202020202020202020202020202F2F2059616E6465';
wwv_flow_api.g_varchar2_table(95) := '780A2020202020202020202020205D2C205B5B4E414D452C202759616E646578275D2C2056455253494F4E5D2C205B0A0A2020202020202020202020202F2870756666696E295C2F285B5C775C2E5D2B292F692020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(96) := '20202020202020202020202020202020202020202020202020202020202F2F2050756666696E0A2020202020202020202020205D2C205B5B4E414D452C202750756666696E275D2C2056455253494F4E5D2C205B0A0A2020202020202020202020202F28';
wwv_flow_api.g_varchar2_table(97) := '666F637573295C2F285B5C775C2E5D2B292F6920202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202F2F2046697265666F7820466F6375730A2020202020202020202020205D2C205B5B';
wwv_flow_api.g_varchar2_table(98) := '4E414D452C202746697265666F7820466F637573275D2C2056455253494F4E5D2C205B0A0A2020202020202020202020202F286F7074295C2F285B5C775C2E5D2B292F692020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(99) := '20202020202020202020202020202020202F2F204F7065726120546F7563680A2020202020202020202020205D2C205B5B4E414D452C20274F7065726120546F756368275D2C2056455253494F4E5D2C205B0A0A2020202020202020202020202F28283F';
wwv_flow_api.g_varchar2_table(100) := '3A5B5C735C2F5D2975633F5C733F62726F777365727C283F3A6A75632E2B297563776562295B5C2F5C735D3F285B5C775C2E5D2B292F692020202020202020202F2F20554342726F777365720A2020202020202020202020205D2C205B5B4E414D452C20';
wwv_flow_api.g_varchar2_table(101) := '27554342726F77736572275D2C2056455253494F4E5D2C205B0A0A2020202020202020202020202F28636F6D6F646F5F647261676F6E295C2F285B5C775C2E5D2B292F692020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(102) := '202020202020202F2F20436F6D6F646F20447261676F6E0A2020202020202020202020205D2C205B5B4E414D452C202F5F2F672C202720275D2C2056455253494F4E5D2C205B0A0A2020202020202020202020202F286D6963726F6D657373656E676572';
wwv_flow_api.g_varchar2_table(103) := '295C2F285B5C775C2E5D2B292F6920202020202020202020202020202020202020202020202020202020202020202020202020202F2F205765436861740A2020202020202020202020205D2C205B5B4E414D452C2027576543686174275D2C2056455253';
wwv_flow_api.g_varchar2_table(104) := '494F4E5D2C205B0A0A2020202020202020202020202F286272617665295C2F285B5C775C2E5D2B292F69202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202F2F2042726176652062726F';
wwv_flow_api.g_varchar2_table(105) := '777365720A2020202020202020202020205D2C205B5B4E414D452C20274272617665275D2C2056455253494F4E5D2C205B0A0A2020202020202020202020202F28717162726F777365726C697465295C2F285B5C775C2E5D2B292F692020202020202020';
wwv_flow_api.g_varchar2_table(106) := '202020202020202020202020202020202020202020202020202020202020202F2F20515142726F777365724C6974650A2020202020202020202020205D2C205B4E414D452C2056455253494F4E5D2C205B0A0A2020202020202020202020202F28515129';
wwv_flow_api.g_varchar2_table(107) := '5C2F285B5C645C2E5D2B292F6920202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202F2F2051512C20616B612053686F75510A2020202020202020202020205D2C205B4E414D45';
wwv_flow_api.g_varchar2_table(108) := '2C2056455253494F4E5D2C205B0A0A2020202020202020202020202F6D3F28717162726F77736572295B5C2F5C735D3F285B5C775C2E5D2B292F692020202020202020202020202020202020202020202020202020202020202020202020202F2F205151';
wwv_flow_api.g_varchar2_table(109) := '42726F777365720A2020202020202020202020205D2C205B4E414D452C2056455253494F4E5D2C205B0A0A2020202020202020202020202F284249445542726F77736572295B5C2F5C735D3F285B5C775C2E5D2B292F6920202020202020202020202020';
wwv_flow_api.g_varchar2_table(110) := '20202020202020202020202020202020202020202020202F2F2042616964752042726F777365720A2020202020202020202020205D2C205B4E414D452C2056455253494F4E5D2C205B0A0A2020202020202020202020202F28323334354578706C6F7265';
wwv_flow_api.g_varchar2_table(111) := '72295B5C2F5C735D3F285B5C775C2E5D2B292F6920202020202020202020202020202020202020202020202020202020202020202020202F2F20323334352042726F777365720A2020202020202020202020205D2C205B4E414D452C2056455253494F4E';
wwv_flow_api.g_varchar2_table(112) := '5D2C205B0A0A2020202020202020202020202F284D6574615372295B5C2F5C735D3F285B5C775C2E5D2B292F6920202020202020202020202020202020202020202020202020202020202020202020202020202020202F2F20536F75476F7542726F7773';
wwv_flow_api.g_varchar2_table(113) := '65720A2020202020202020202020205D2C205B4E414D455D2C205B0A0A2020202020202020202020202F284C4242524F57534552292F6920202020202020202020202020202020202020202020202020202020202020202020202020202F2F204C696542';
wwv_flow_api.g_varchar2_table(114) := '616F2042726F777365720A2020202020202020202020205D2C205B4E414D455D2C205B0A0A2020202020202020202020202F7869616F6D695C2F6D69756962726F777365725C2F285B5C775C2E5D2B292F69202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(115) := '20202020202020202020202020202020202F2F204D4955492042726F777365720A2020202020202020202020205D2C205B56455253494F4E2C205B4E414D452C20274D4955492042726F77736572275D5D2C205B0A0A2020202020202020202020202F3B';
wwv_flow_api.g_varchar2_table(116) := '666261765C2F285B5C775C2E5D2B293B2F692020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202F2F2046616365626F6F6B2041707020666F7220694F53202620416E64726F69640A';
wwv_flow_api.g_varchar2_table(117) := '2020202020202020202020205D2C205B56455253494F4E2C205B4E414D452C202746616365626F6F6B275D5D2C205B0A0A2020202020202020202020202F7361666172695C73286C696E65295C2F285B5C775C2E5D2B292F692C20202020202020202020';
wwv_flow_api.g_varchar2_table(118) := '20202020202020202020202020202020202020202020202020202020202F2F204C696E652041707020666F7220694F530A2020202020202020202020202F616E64726F69642E2B286C696E65295C2F285B5C775C2E5D2B295C2F6961622F692020202020';
wwv_flow_api.g_varchar2_table(119) := '20202020202020202020202020202020202020202020202020202020202F2F204C696E652041707020666F7220416E64726F69640A2020202020202020202020205D2C205B4E414D452C2056455253494F4E5D2C205B0A0A202020202020202020202020';
wwv_flow_api.g_varchar2_table(120) := '2F686561646C6573736368726F6D65283F3A5C2F285B5C775C2E5D2B297C5C73292F692020202020202020202020202020202020202020202020202020202020202020202F2F204368726F6D6520486561646C6573730A2020202020202020202020205D';
wwv_flow_api.g_varchar2_table(121) := '2C205B56455253494F4E2C205B4E414D452C20274368726F6D6520486561646C657373275D5D2C205B0A0A2020202020202020202020202F5C7377765C292E2B286368726F6D65295C2F285B5C775C2E5D2B292F69202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(122) := '20202020202020202020202020202020202020202020202F2F204368726F6D6520576562566965770A2020202020202020202020205D2C205B5B4E414D452C202F282E2B292F2C202724312057656256696577275D2C2056455253494F4E5D2C205B0A0A';
wwv_flow_api.g_varchar2_table(123) := '2020202020202020202020202F28283F3A6F63756C75737C73616D73756E672962726F77736572295C2F285B5C775C2E5D2B292F690A2020202020202020202020205D2C205B5B4E414D452C202F282E2B283F3A677C75732929282E2B292F2C20272431';
wwv_flow_api.g_varchar2_table(124) := '202432275D2C2056455253494F4E5D2C205B202020202020202020202020202020202F2F204F63756C7573202F2053616D73756E672042726F777365720A0A2020202020202020202020202F616E64726F69642E2B76657273696F6E5C2F285B5C775C2E';
wwv_flow_api.g_varchar2_table(125) := '5D2B295C732B283F3A6D6F62696C655C733F7361666172697C736166617269292A2F6920202020202020202F2F20416E64726F69642042726F777365720A2020202020202020202020205D2C205B56455253494F4E2C205B4E414D452C2027416E64726F';
wwv_flow_api.g_varchar2_table(126) := '69642042726F77736572275D5D2C205B0A0A2020202020202020202020202F286368726F6D657C6F6D6E697765627C61726F72617C5B74697A656E6F6B615D7B357D5C733F62726F77736572295C2F763F285B5C775C2E5D2B292F690A20202020202020';
wwv_flow_api.g_varchar2_table(127) := '202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202F2F204368726F6D652F4F6D6E695765622F41726F72612F54697A';
wwv_flow_api.g_varchar2_table(128) := '656E2F4E6F6B69610A2020202020202020202020205D2C205B4E414D452C2056455253494F4E5D2C205B0A0A2020202020202020202020202F28646F6C66696E295C2F285B5C775C2E5D2B292F6920202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(129) := '2020202020202020202020202020202020202020202020202F2F20446F6C7068696E0A2020202020202020202020205D2C205B5B4E414D452C2027446F6C7068696E275D2C2056455253494F4E5D2C205B0A0A2020202020202020202020202F28283F3A';
wwv_flow_api.g_varchar2_table(130) := '616E64726F69642E2B2963726D6F7C6372696F73295C2F285B5C775C2E5D2B292F6920202020202020202020202020202020202020202020202020202020202F2F204368726F6D6520666F7220416E64726F69642F694F530A2020202020202020202020';
wwv_flow_api.g_varchar2_table(131) := '205D2C205B5B4E414D452C20274368726F6D65275D2C2056455253494F4E5D2C205B0A0A2020202020202020202020202F28636F617374295C2F285B5C775C2E5D2B292F6920202020202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(132) := '202020202020202020202020202020202F2F204F7065726120436F6173740A2020202020202020202020205D2C205B5B4E414D452C20274F7065726120436F617374275D2C2056455253494F4E5D2C205B0A0A2020202020202020202020202F6678696F';
wwv_flow_api.g_varchar2_table(133) := '735C2F285B5C775C2E2D5D2B292F692020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202F2F2046697265666F7820666F7220694F530A2020202020202020202020205D2C205B5645';
wwv_flow_api.g_varchar2_table(134) := '5253494F4E2C205B4E414D452C202746697265666F78275D5D2C205B0A0A2020202020202020202020202F76657273696F6E5C2F285B5C775C2E5D2B292E2B3F6D6F62696C655C2F5C772B5C7328736166617269292F6920202020202020202020202020';
wwv_flow_api.g_varchar2_table(135) := '202020202020202020202F2F204D6F62696C65205361666172690A2020202020202020202020205D2C205B56455253494F4E2C205B4E414D452C20274D6F62696C6520536166617269275D5D2C205B0A0A2020202020202020202020202F76657273696F';
wwv_flow_api.g_varchar2_table(136) := '6E5C2F285B5C775C2E5D2B292E2B3F286D6F62696C655C733F7361666172697C736166617269292F6920202020202020202020202020202020202020202F2F20536166617269202620536166617269204D6F62696C650A2020202020202020202020205D';
wwv_flow_api.g_varchar2_table(137) := '2C205B56455253494F4E2C204E414D455D2C205B0A0A2020202020202020202020202F7765626B69742E2B3F28677361295C2F285B5C775C2E5D2B292E2B3F286D6F62696C655C733F7361666172697C73616661726929285C2F5B5C775C2E5D2B292F69';
wwv_flow_api.g_varchar2_table(138) := '20202F2F20476F6F676C6520536561726368204170706C69616E6365206F6E20694F530A2020202020202020202020205D2C205B5B4E414D452C2027475341275D2C2056455253494F4E5D2C205B0A0A2020202020202020202020202F7765626B69742E';
wwv_flow_api.g_varchar2_table(139) := '2B3F286D6F62696C655C733F7361666172697C73616661726929285C2F5B5C775C2E5D2B292F692020202020202020202020202020202020202020202F2F20536166617269203C20332E300A2020202020202020202020205D2C205B4E414D452C205B56';
wwv_flow_api.g_varchar2_table(140) := '455253494F4E2C206D61707065722E7374722C206D6170732E62726F777365722E6F6C647361666172692E76657273696F6E5D5D2C205B0A0A2020202020202020202020202F286B6F6E717565726F72295C2F285B5C775C2E5D2B292F692C2020202020';
wwv_flow_api.g_varchar2_table(141) := '202020202020202020202020202020202020202020202020202020202020202020202020202F2F204B6F6E717565726F720A2020202020202020202020202F287765626B69747C6B68746D6C295C2F285B5C775C2E5D2B292F690A202020202020202020';
wwv_flow_api.g_varchar2_table(142) := '2020205D2C205B4E414D452C2056455253494F4E5D2C205B0A0A2020202020202020202020202F2F204765636B6F2062617365640A2020202020202020202020202F286E6176696761746F727C6E65747363617065295C2F285B5C775C2E2D5D2B292F69';
wwv_flow_api.g_varchar2_table(143) := '2020202020202020202020202020202020202020202020202020202020202020202F2F204E657473636170650A2020202020202020202020205D2C205B5B4E414D452C20274E65747363617065275D2C2056455253494F4E5D2C205B0A20202020202020';
wwv_flow_api.g_varchar2_table(144) := '20202020202F287377696674666F78292F692C2020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202F2F205377696674666F780A2020202020202020202020202F2869';
wwv_flow_api.g_varchar2_table(145) := '6365647261676F6E7C69636577656173656C7C63616D696E6F7C6368696D6572617C66656E6E65637C6D61656D6F5C7362726F777365727C6D696E696D6F7C636F6E6B65726F72295B5C2F5C735D3F285B5C775C2E5C2B5D2B292F692C0A202020202020';
wwv_flow_api.g_varchar2_table(146) := '20202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202F2F20496365447261676F6E2F49636577656173656C2F43616D';
wwv_flow_api.g_varchar2_table(147) := '696E6F2F4368696D6572612F46656E6E65632F4D61656D6F2F4D696E696D6F2F436F6E6B65726F720A2020202020202020202020202F2866697265666F787C7365616D6F6E6B65797C6B2D6D656C656F6E7C6963656361747C6963656170657C66697265';
wwv_flow_api.g_varchar2_table(148) := '626972647C70686F656E69787C70616C656D6F6F6E7C626173696C69736B7C7761746572666F78295C2F285B5C775C2E2D5D2B29242F692C0A0A202020202020202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(149) := '20202020202020202020202020202020202020202020202020202020202020202020202020202F2F2046697265666F782F5365614D6F6E6B65792F4B2D4D656C656F6E2F4963654361742F4963654170652F46697265626972642F50686F656E69780A20';
wwv_flow_api.g_varchar2_table(150) := '20202020202020202020202F286D6F7A696C6C61295C2F285B5C775C2E5D2B292E2B72765C3A2E2B6765636B6F5C2F5C642B2F692C20202020202020202020202020202020202020202020202020202F2F204D6F7A696C6C610A0A202020202020202020';
wwv_flow_api.g_varchar2_table(151) := '2020202F2F204F746865720A2020202020202020202020202F28706F6C617269737C6C796E787C64696C6C6F7C696361627C646F7269737C616D6179617C77336D7C6E6574737572667C736C6569706E6972295B5C2F5C735D3F285B5C775C2E5D2B292F';
wwv_flow_api.g_varchar2_table(152) := '692C0A20202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202F2F20506F6C617269732F4C796E782F44';
wwv_flow_api.g_varchar2_table(153) := '696C6C6F2F694361622F446F7269732F416D6179612F77336D2F4E6574537572662F536C6569706E69720A2020202020202020202020202F286C696E6B73295C735C28285B5C775C2E5D2B292F692C202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(154) := '20202020202020202020202020202020202020202020202F2F204C696E6B730A2020202020202020202020202F28676F62726F77736572295C2F3F285B5C775C2E5D2A292F692C2020202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(155) := '2020202020202020202020202F2F20476F42726F777365720A2020202020202020202020202F286963655C733F62726F77736572295C2F763F285B5C775C2E5F5D2B292F692C202020202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(156) := '20202020202F2F204943452042726F777365720A2020202020202020202020202F286D6F73616963295B5C2F5C735D285B5C775C2E5D2B292F69202020202020202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(157) := '2F2F204D6F736169630A2020202020202020202020205D2C205B4E414D452C2056455253494F4E5D0A0A2020202020202020202020202F2A202F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F0A2020202020202020202020202F2F204D6564696120';
wwv_flow_api.g_varchar2_table(158) := '706C617965727320424547494E0A2020202020202020202020202F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F0A0A2020202020202020202020202C205B0A0A2020202020202020202020202F286170706C65283F3A636F72656D65646961';
wwv_flow_api.g_varchar2_table(159) := '7C29295C2F28285C642B295B5C775C2E5F5D2B292F692C20202020202020202020202020202020202020202020202020202F2F2047656E65726963204170706C6520436F72654D656469610A2020202020202020202020202F28636F72656D6564696129';
wwv_flow_api.g_varchar2_table(160) := '207628285C642B295B5C775C2E5F5D2B292F690A2020202020202020202020205D2C205B4E414D452C2056455253494F4E5D2C205B0A0A2020202020202020202020202F28617175616C756E677C6C7973736E617C6273706C61796572295C2F28285C64';
wwv_flow_api.g_varchar2_table(161) := '2B293F5B5C775C2E2D5D2B292F692020202020202020202020202020202020202020202F2F20417175616C756E672F4C7973736E612F4253506C617965720A2020202020202020202020205D2C205B4E414D452C2056455253494F4E5D2C205B0A0A2020';
wwv_flow_api.g_varchar2_table(162) := '202020202020202020202F28617265737C6F737370726F7879295C7328285C642B295B5C775C2E2D5D2B292F692020202020202020202020202020202020202020202020202020202020202020202F2F20417265732F4F535350726F78790A2020202020';
wwv_flow_api.g_varchar2_table(163) := '202020202020205D2C205B4E414D452C2056455253494F4E5D2C205B0A0A2020202020202020202020202F286175646163696F75737C617564696D7573696373747265616D7C616D61726F6B7C626173737C636F72657C64616C76696B7C676E6F6D656D';
wwv_flow_api.g_varchar2_table(164) := '706C617965727C6D75736963206F6E20636F6E736F6C657C6E73706C617965727C7073702D696E7465726E6574726164696F706C617965727C766964656F73295C2F28285C642B295B5C775C2E2D5D2B292F692C0A202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(165) := '20202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202F2F204175646163696F75732F417564694D7573696353747265616D2F416D61726F6B';
wwv_flow_api.g_varchar2_table(166) := '2F424153532F4F70656E434F52452F44616C76696B2F476E6F6D654D706C617965722F4D6F430A20202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(167) := '202020202020202020202020202020202020202F2F204E53506C617965722F5053502D496E7465726E6574526164696F506C617965722F566964656F730A2020202020202020202020202F28636C656D656E74696E657C6D7573696320706C6179657220';
wwv_flow_api.g_varchar2_table(168) := '6461656D6F6E295C7328285C642B295B5C775C2E2D5D2B292F692C2020202020202020202020202020202F2F20436C656D656E74696E652F4D50440A2020202020202020202020202F286C6720706C617965727C6E6578706C61796572295C7328285C64';
wwv_flow_api.g_varchar2_table(169) := '2B295B5C645C2E5D2B292F692C0A2020202020202020202020202F706C617965725C2F286E6578706C617965727C6C6720706C61796572295C7328285C642B295B5C775C2E2D5D2B292F69202020202020202020202020202020202020202F2F204E6578';
wwv_flow_api.g_varchar2_table(170) := '506C617965722F4C4720506C617965720A2020202020202020202020205D2C205B4E414D452C2056455253494F4E5D2C205B0A2020202020202020202020202F286E6578706C61796572295C7328285C642B295B5C775C2E2D5D2B292F69202020202020';
wwv_flow_api.g_varchar2_table(171) := '202020202020202020202020202020202020202020202020202020202020202F2F204E6578706C617965720A2020202020202020202020205D2C205B4E414D452C2056455253494F4E5D2C205B0A0A2020202020202020202020202F28666C7270295C2F';
wwv_flow_api.g_varchar2_table(172) := '28285C642B295B5C775C2E2D5D2B292F692020202020202020202020202020202020202020202020202020202020202020202020202020202020202F2F20466C697020506C617965720A2020202020202020202020205D2C205B5B4E414D452C2027466C';
wwv_flow_api.g_varchar2_table(173) := '697020506C61796572275D2C2056455253494F4E5D2C205B0A0A2020202020202020202020202F286673747265616D7C6E6174697665686F73747C71756572797365656B7370696465727C69612D61726368697665727C66616365626F6F6B6578746572';
wwv_flow_api.g_varchar2_table(174) := '6E616C686974292F690A20202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202F2F204653747265616D';
wwv_flow_api.g_varchar2_table(175) := '2F4E6174697665486F73742F51756572795365656B5370696465722F49412041726368697665722F66616365626F6F6B65787465726E616C6869740A2020202020202020202020205D2C205B4E414D455D2C205B0A0A2020202020202020202020202F28';
wwv_flow_api.g_varchar2_table(176) := '6773747265616D65722920736F75706874747073726320283F3A5C285B5E5C295D2B5C29297B302C317D206C6962736F75705C2F28285C642B295B5C775C2E2D5D2B292F690A202020202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(177) := '20202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202F2F204773747265616D65720A2020202020202020202020205D2C205B4E414D452C2056455253494F4E5D2C205B0A0A2020';
wwv_flow_api.g_varchar2_table(178) := '202020202020202020202F286874632073747265616D696E6720706C61796572295C735B5C775F5D2B5C735C2F5C7328285C642B295B5C645C2E5D2B292F692C20202020202020202020202020202F2F204854432053747265616D696E6720506C617965';
wwv_flow_api.g_varchar2_table(179) := '720A2020202020202020202020202F286A6176617C707974686F6E2D75726C6C69627C707974686F6E2D72657175657374737C776765747C6C69626375726C295C2F28285C642B295B5C775C2E2D5F5D2B292F692C0A2020202020202020202020202020';
wwv_flow_api.g_varchar2_table(180) := '2020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202F2F204A6176612F75726C6C69622F72657175657374732F776765742F6355524C0A';
wwv_flow_api.g_varchar2_table(181) := '2020202020202020202020202F286C6176662928285C642B295B5C645C2E5D2B292F692020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202F2F204C617666202846464D504547290A202020';
wwv_flow_api.g_varchar2_table(182) := '2020202020202020205D2C205B4E414D452C2056455253494F4E5D2C205B0A0A2020202020202020202020202F286874635F6F6E655F73295C2F28285C642B295B5C645C2E5D2B292F692020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(183) := '2020202020202020202020202F2F20485443204F6E6520530A2020202020202020202020205D2C205B5B4E414D452C202F5F2F672C202720275D2C2056455253494F4E5D2C205B0A0A2020202020202020202020202F286D706C6179657229283F3A5C73';
wwv_flow_api.g_varchar2_table(184) := '7C5C2F29283F3A283F3A736865727079612D297B302C317D73766E29283F3A2D7C5C732928725C642B283F3A2D5C642B5B5C775C2E2D5D2B297B302C317D292F690A20202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(185) := '202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202F2F204D506C617965722053564E0A2020202020202020202020205D2C205B4E414D452C2056455253494F4E5D2C205B0A0A20202020';
wwv_flow_api.g_varchar2_table(186) := '20202020202020202F286D706C6179657229283F3A5C737C5C2F7C5B756E6B6F772D5D2B2928285C642B295B5C775C2E2D5D2B292F69202020202020202020202020202020202020202020202F2F204D506C617965720A2020202020202020202020205D';
wwv_flow_api.g_varchar2_table(187) := '2C205B4E414D452C2056455253494F4E5D2C205B0A0A2020202020202020202020202F286D706C61796572292F692C2020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(188) := '20202F2F204D506C6179657220286E6F206F7468657220696E666F290A2020202020202020202020202F28796F75726D757A65292F692C202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(189) := '2020202020202020202F2F20596F75724D757A650A2020202020202020202020202F286D6564696120706C6179657220636C61737369637C6E65726F2073686F7774696D65292F6920202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(190) := '202F2F204D6564696120506C6179657220436C61737369632F4E65726F2053686F7754696D650A2020202020202020202020205D2C205B4E414D455D2C205B0A0A2020202020202020202020202F286E65726F20283F3A686F6D657C73636F757429295C';
wwv_flow_api.g_varchar2_table(191) := '2F28285C642B295B5C775C2E2D5D2B292F692020202020202020202020202020202020202020202020202020202F2F204E65726F20486F6D652F4E65726F2053636F75740A2020202020202020202020205D2C205B4E414D452C2056455253494F4E5D2C';
wwv_flow_api.g_varchar2_table(192) := '205B0A0A2020202020202020202020202F286E6F6B69615C642B295C2F28285C642B295B5C775C2E2D5D2B292F6920202020202020202020202020202020202020202020202020202020202020202020202020202F2F204E6F6B69610A20202020202020';
wwv_flow_api.g_varchar2_table(193) := '20202020205D2C205B4E414D452C2056455253494F4E5D2C205B0A0A2020202020202020202020202F5C7328736F6E6762697264295C2F28285C642B295B5C775C2E2D5D2B292F6920202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(194) := '20202020202020202F2F20536F6E67626972642F5068696C6970732D536F6E67626972640A2020202020202020202020205D2C205B4E414D452C2056455253494F4E5D2C205B0A0A2020202020202020202020202F2877696E616D702933207665727369';
wwv_flow_api.g_varchar2_table(195) := '6F6E2028285C642B295B5C775C2E2D5D2B292F692C202020202020202020202020202020202020202020202020202020202020202F2F2057696E616D700A2020202020202020202020202F2877696E616D70295C7328285C642B295B5C775C2E2D5D2B29';
wwv_flow_api.g_varchar2_table(196) := '2F692C0A2020202020202020202020202F2877696E616D70296D7065675C2F28285C642B295B5C775C2E2D5D2B292F690A2020202020202020202020205D2C205B4E414D452C2056455253494F4E5D2C205B0A0A2020202020202020202020202F286F63';
wwv_flow_api.g_varchar2_table(197) := '6D732D626F747C746170696E726164696F7C74756E65696E20726164696F7C756E6B6E6F776E7C77696E616D707C696E6C6967687420726164696F292F6920202F2F204F434D532D626F742F74617020696E20726164696F2F74756E65696E2F756E6B6E';
wwv_flow_api.g_varchar2_table(198) := '6F776E2F77696E616D7020286E6F206F7468657220696E666F290A20202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(199) := '202020202020202F2F20696E6C6967687420726164696F0A2020202020202020202020205D2C205B4E414D455D2C205B0A0A2020202020202020202020202F28717569636B74696D657C726D617C726164696F6170707C726164696F636C69656E746170';
wwv_flow_api.g_varchar2_table(200) := '706C69636174696F6E7C736F756E647461707C746F74656D7C73746167656672696768747C73747265616D69756D295C2F28285C642B295B5C775C2E2D5D2B292F690A202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(201) := '20202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202F2F20517569636B54696D652F5265616C4D656469612F526164696F4170702F526164696F436C69656E744170706C69636174696F';
wwv_flow_api.g_varchar2_table(202) := '6E2F0A20202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202F2F20536F756E645461702F546F74656D';
wwv_flow_api.g_varchar2_table(203) := '2F53746167656672696768742F53747265616D69756D0A2020202020202020202020205D2C205B4E414D452C2056455253494F4E5D2C205B0A0A2020202020202020202020202F28736D702928285C642B295B5C645C2E5D2B292F692020202020202020';
wwv_flow_api.g_varchar2_table(204) := '20202020202020202020202020202020202020202020202020202020202020202020202020202F2F20534D500A2020202020202020202020205D2C205B4E414D452C2056455253494F4E5D2C205B0A0A2020202020202020202020202F28766C6329206D';
wwv_flow_api.g_varchar2_table(205) := '6564696120706C61796572202D2076657273696F6E2028285C642B295B5C775C2E5D2B292F692C2020202020202020202020202020202020202020202F2F20564C4320566964656F6C616E0A2020202020202020202020202F28766C63295C2F28285C64';
wwv_flow_api.g_varchar2_table(206) := '2B295B5C775C2E2D5D2B292F692C0A2020202020202020202020202F2878626D637C677666737C78696E657C786D6D737C6972617070295C2F28285C642B295B5C775C2E2D5D2B292F692C20202020202020202020202020202020202020202F2F205842';
wwv_flow_api.g_varchar2_table(207) := '4D432F677666732F58696E652F584D4D532F69726170700A2020202020202020202020202F28666F6F62617232303030295C2F28285C642B295B5C645C2E5D2B292F692C2020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(208) := '202020202F2F20466F6F626172323030300A2020202020202020202020202F286974756E6573295C2F28285C642B295B5C645C2E5D2B292F6920202020202020202020202020202020202020202020202020202020202020202020202020202020202F2F';
wwv_flow_api.g_varchar2_table(209) := '206954756E65730A2020202020202020202020205D2C205B4E414D452C2056455253494F4E5D2C205B0A0A2020202020202020202020202F28776D706C61796572295C2F28285C642B295B5C775C2E2D5D2B292F692C2020202020202020202020202020';
wwv_flow_api.g_varchar2_table(210) := '20202020202020202020202020202020202020202020202F2F2057696E646F7773204D6564696120506C617965720A2020202020202020202020202F2877696E646F77732D6D656469612D706C61796572295C2F28285C642B295B5C775C2E2D5D2B292F';
wwv_flow_api.g_varchar2_table(211) := '690A2020202020202020202020205D2C205B5B4E414D452C202F2D2F672C202720275D2C2056455253494F4E5D2C205B0A0A2020202020202020202020202F77696E646F77735C2F28285C642B295B5C775C2E2D5D2B292075706E705C2F5B5C645C2E5D';
wwv_flow_api.g_varchar2_table(212) := '2B20646C6E61646F635C2F5B5C645C2E5D2B2028686F6D65206D6564696120736572766572292F690A2020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(213) := '2020202020202020202020202020202020202020202F2F2057696E646F7773204D65646961205365727665720A2020202020202020202020205D2C205B56455253494F4E2C205B4E414D452C202757696E646F7773275D5D2C205B0A0A20202020202020';
wwv_flow_api.g_varchar2_table(214) := '20202020202F28636F6D5C2E726973657570726164696F616C61726D295C2F28285C642B295B5C645C2E5D2A292F6920202020202020202020202020202020202020202020202020202F2F2052697365555020526164696F20416C61726D0A2020202020';
wwv_flow_api.g_varchar2_table(215) := '202020202020205D2C205B4E414D452C2056455253494F4E5D2C205B0A0A2020202020202020202020202F287261642E696F295C7328285C642B295B5C645C2E5D2B292F692C202020202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(216) := '202020202020202020202F2F205261642E696F0A2020202020202020202020202F28726164696F2E283F3A64657C61747C667229295C7328285C642B295B5C645C2E5D2B292F690A2020202020202020202020205D2C205B5B4E414D452C20277261642E';
wwv_flow_api.g_varchar2_table(217) := '696F275D2C2056455253494F4E5D0A0A2020202020202020202020202F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F0A2020202020202020202020202F2F204D6564696120706C617965727320454E440A2020202020202020202020202F2F2F2F';
wwv_flow_api.g_varchar2_table(218) := '2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2A2F0A0A20202020202020205D2C0A0A2020202020202020637075203A205B5B0A0A2020202020202020202020202F283F3A28616D647C78283F3A283F3A38367C3634295B5F2D5D293F7C776F777C77696E2936';
wwv_flow_api.g_varchar2_table(219) := '34295B3B5C295D2F692020202020202020202020202020202020202020202F2F20414D4436340A2020202020202020202020205D2C205B5B4152434849544543545552452C2027616D643634275D5D2C205B0A0A2020202020202020202020202F286961';
wwv_flow_api.g_varchar2_table(220) := '3332283F3D3B29292F692020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202F2F20494133322028717569636B74696D65290A2020202020202020202020205D2C205B';
wwv_flow_api.g_varchar2_table(221) := '5B4152434849544543545552452C207574696C2E6C6F776572697A655D5D2C205B0A0A2020202020202020202020202F28283F3A695B3334365D7C78293836295B3B5C295D2F692020202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(222) := '2020202020202020202020202020202F2F20494133320A2020202020202020202020205D2C205B5B4152434849544543545552452C202769613332275D5D2C205B0A0A2020202020202020202020202F2F20506F636B65745043206D697374616B656E6C';
wwv_flow_api.g_varchar2_table(223) := '79206964656E74696669656420617320506F77657250430A2020202020202020202020202F77696E646F77735C732863657C6D6F62696C65293B5C737070633B2F690A2020202020202020202020205D2C205B5B4152434849544543545552452C202761';
wwv_flow_api.g_varchar2_table(224) := '726D275D5D2C205B0A0A2020202020202020202020202F28283F3A7070637C706F776572706329283F3A3634293F29283F3A5C736D61637C3B7C5C29292F692020202020202020202020202020202020202020202020202020202F2F20506F7765725043';
wwv_flow_api.g_varchar2_table(225) := '0A2020202020202020202020205D2C205B5B4152434849544543545552452C202F6F7765722F2C2027272C207574696C2E6C6F776572697A655D5D2C205B0A0A2020202020202020202020202F2873756E345C77295B3B5C295D2F692020202020202020';
wwv_flow_api.g_varchar2_table(226) := '20202020202020202020202020202020202020202020202020202020202020202020202020202020202020202F2F2053504152430A2020202020202020202020205D2C205B5B4152434849544543545552452C20277370617263275D5D2C205B0A0A2020';
wwv_flow_api.g_varchar2_table(227) := '202020202020202020202F28283F3A61767233327C69613634283F3D3B29297C36386B283F3D5C29297C61726D283F3A36347C283F3D765C642B5B3B6C5D29297C283F3D61746D656C5C73296176727C283F3A697269787C6D6970737C73706172632928';
wwv_flow_api.g_varchar2_table(228) := '3F3A3634293F283F3D3B297C70612D72697363292F690A2020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(229) := '2020202F2F20494136342C2036384B2C2041524D2F36342C204156522F33322C20495249582F36342C204D4950532F36342C2053504152432F36342C2050412D524953430A2020202020202020202020205D2C205B5B4152434849544543545552452C20';
wwv_flow_api.g_varchar2_table(230) := '7574696C2E6C6F776572697A655D5D0A20202020202020205D2C0A0A2020202020202020646576696365203A205B5B0A0A2020202020202020202020202F5C2828697061647C706C6179626F6F6B293B5B5C775C735C293B2D5D2B2872696D7C6170706C';
wwv_flow_api.g_varchar2_table(231) := '65292F69202020202020202020202020202020202020202020202020202F2F20695061642F506C6179426F6F6B0A2020202020202020202020205D2C205B4D4F44454C2C2056454E444F522C205B545950452C205441424C45545D5D2C205B0A0A202020';
wwv_flow_api.g_varchar2_table(232) := '2020202020202020202F6170706C65636F72656D656469615C2F5B5C775C2E5D2B205C282869706164292F202020202020202020202020202020202020202020202020202020202020202020202F2F20695061640A2020202020202020202020205D2C20';
wwv_flow_api.g_varchar2_table(233) := '5B4D4F44454C2C205B56454E444F522C20274170706C65275D2C205B545950452C205441424C45545D5D2C205B0A0A2020202020202020202020202F286170706C655C737B302C317D7476292F6920202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(234) := '2020202020202020202020202020202020202020202020202020202F2F204170706C652054560A2020202020202020202020205D2C205B5B4D4F44454C2C20274170706C65205456275D2C205B56454E444F522C20274170706C65275D5D2C205B0A0A20';
wwv_flow_api.g_varchar2_table(235) := '20202020202020202020202F28617263686F73295C732867616D65706164323F292F692C202020202020202020202020202020202020202020202020202020202020202020202020202020202020202F2F20417263686F730A2020202020202020202020';
wwv_flow_api.g_varchar2_table(236) := '202F286870292E2B28746F756368706164292F692C2020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202F2F20485020546F7563685061640A2020202020202020202020202F286870';
wwv_flow_api.g_varchar2_table(237) := '292E2B287461626C6574292F692C20202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202F2F204850205461626C65740A2020202020202020202020202F286B696E646C65295C2F';
wwv_flow_api.g_varchar2_table(238) := '285B5C775C2E5D2B292F692C2020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202F2F204B696E646C650A2020202020202020202020202F5C73286E6F6F6B295B5C775C735D2B6275696C64';
wwv_flow_api.g_varchar2_table(239) := '5C2F285C772B292F692C202020202020202020202020202020202020202020202020202020202020202020202020202F2F204E6F6F6B0A2020202020202020202020202F2864656C6C295C732873747265615B6B70725C735C645D2A5B5C646B6F5D292F';
wwv_flow_api.g_varchar2_table(240) := '69202020202020202020202020202020202020202020202020202020202020202020202F2F2044656C6C2053747265616B0A2020202020202020202020205D2C205B56454E444F522C204D4F44454C2C205B545950452C205441424C45545D5D2C205B0A';
wwv_flow_api.g_varchar2_table(241) := '0A2020202020202020202020202F286B665B412D7A5D2B295C736275696C645C2F2E2B73696C6B5C2F2F6920202020202020202020202020202020202020202020202020202020202020202020202020202F2F204B696E646C6520466972652048440A20';
wwv_flow_api.g_varchar2_table(242) := '20202020202020202020205D2C205B4D4F44454C2C205B56454E444F522C2027416D617A6F6E275D2C205B545950452C205441424C45545D5D2C205B0A2020202020202020202020202F2873647C6B66295B3033343968696A6F72737475775D2B5C7362';
wwv_flow_api.g_varchar2_table(243) := '75696C645C2F2E2B73696C6B5C2F2F69202020202020202020202020202020202020202020202020202F2F20466972652050686F6E650A2020202020202020202020205D2C205B5B4D4F44454C2C206D61707065722E7374722C206D6170732E64657669';
wwv_flow_api.g_varchar2_table(244) := '63652E616D617A6F6E2E6D6F64656C5D2C205B56454E444F522C2027416D617A6F6E275D2C205B545950452C204D4F42494C455D5D2C205B0A2020202020202020202020202F616E64726F69642E2B616674285B626D735D295C736275696C642F692020';
wwv_flow_api.g_varchar2_table(245) := '202020202020202020202020202020202020202020202020202020202020202020202020202F2F20466972652054560A2020202020202020202020205D2C205B4D4F44454C2C205B56454E444F522C2027416D617A6F6E275D2C205B545950452C20534D';
wwv_flow_api.g_varchar2_table(246) := '41525454565D5D2C205B0A0A2020202020202020202020202F5C282869705B686F6E65647C5C735C772A5D2B293B2E2B286170706C65292F6920202020202020202020202020202020202020202020202020202020202020202020202F2F2069506F642F';
wwv_flow_api.g_varchar2_table(247) := '6950686F6E650A2020202020202020202020205D2C205B4D4F44454C2C2056454E444F522C205B545950452C204D4F42494C455D5D2C205B0A2020202020202020202020202F5C282869705B686F6E65647C5C735C772A5D2B293B2F6920202020202020';
wwv_flow_api.g_varchar2_table(248) := '202020202020202020202020202020202020202020202020202020202020202020202020202F2F2069506F642F6950686F6E650A2020202020202020202020205D2C205B4D4F44454C2C205B56454E444F522C20274170706C65275D2C205B545950452C';
wwv_flow_api.g_varchar2_table(249) := '204D4F42494C455D5D2C205B0A0A2020202020202020202020202F28626C61636B6265727279295B5C732D5D3F285C772B292F692C20202020202020202020202020202020202020202020202020202020202020202020202020202020202F2F20426C61';
wwv_flow_api.g_varchar2_table(250) := '636B42657272790A2020202020202020202020202F28626C61636B62657272797C62656E717C70616C6D283F3D5C2D297C736F6E796572696373736F6E7C616365727C617375737C64656C6C7C6D65697A757C6D6F746F726F6C617C706F6C7974726F6E';
wwv_flow_api.g_varchar2_table(251) := '295B5C735F2D5D3F285B5C772D5D2A292F692C0A2020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(252) := '2F2F2042656E512F50616C6D2F536F6E792D4572696373736F6E2F416365722F417375732F44656C6C2F4D65697A752F4D6F746F726F6C612F506F6C7974726F6E0A2020202020202020202020202F286870295C73285B5C775C735D2B5C77292F692C20';
wwv_flow_api.g_varchar2_table(253) := '202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202F2F20485020695041510A2020202020202020202020202F2861737573292D3F285C772B292F69202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(254) := '202020202020202020202020202020202020202020202020202020202020202020202020202F2F20417375730A2020202020202020202020205D2C205B56454E444F522C204D4F44454C2C205B545950452C204D4F42494C455D5D2C205B0A2020202020';
wwv_flow_api.g_varchar2_table(255) := '202020202020202F5C28626231303B5C73285C772B292F692020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202F2F20426C61636B42657272792031300A2020202020202020';
wwv_flow_api.g_varchar2_table(256) := '202020205D2C205B4D4F44454C2C205B56454E444F522C2027426C61636B4265727279275D2C205B545950452C204D4F42494C455D5D2C205B0A202020202020202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(257) := '20202020202020202020202020202020202020202020202020202020202020202020202020202F2F2041737573205461626C6574730A2020202020202020202020202F616E64726F69642E2B287472616E73666F5B7072696D655C735D7B342C31307D5C';
wwv_flow_api.g_varchar2_table(258) := '735C772B7C65656570637C736C696465725C735C772B7C6E6578757320377C706164666F6E65292F690A2020202020202020202020205D2C205B4D4F44454C2C205B56454E444F522C202741737573275D2C205B545950452C205441424C45545D5D2C20';
wwv_flow_api.g_varchar2_table(259) := '5B0A0A2020202020202020202020202F28736F6E79295C73287461626C65745C735B70735D295C736275696C645C2F2F692C202020202020202020202020202020202020202020202020202020202020202020202F2F20536F6E790A2020202020202020';
wwv_flow_api.g_varchar2_table(260) := '202020202F28736F6E79293F283F3A7367702E2B295C736275696C645C2F2F690A2020202020202020202020205D2C205B5B56454E444F522C2027536F6E79275D2C205B4D4F44454C2C2027587065726961205461626C6574275D2C205B545950452C20';
wwv_flow_api.g_varchar2_table(261) := '5441424C45545D5D2C205B0A2020202020202020202020202F616E64726F69642E2B5C73285B632D675D5C647B347D7C736F5B2D6C5D5C772B295C736275696C645C2F2F690A2020202020202020202020205D2C205B4D4F44454C2C205B56454E444F52';
wwv_flow_api.g_varchar2_table(262) := '2C2027536F6E79275D2C205B545950452C204D4F42494C455D5D2C205B0A0A2020202020202020202020202F5C73286F757961295C732F692C20202020202020202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(263) := '20202020202020202020202F2F204F7579610A2020202020202020202020202F286E696E74656E646F295C73285B7769647333755D2B292F692020202020202020202020202020202020202020202020202020202020202020202020202020202020202F';
wwv_flow_api.g_varchar2_table(264) := '2F204E696E74656E646F0A2020202020202020202020205D2C205B56454E444F522C204D4F44454C2C205B545950452C20434F4E534F4C455D5D2C205B0A0A2020202020202020202020202F616E64726F69642E2B3B5C7328736869656C64295C736275';
wwv_flow_api.g_varchar2_table(265) := '696C642F6920202020202020202020202020202020202020202020202020202020202020202020202020202F2F204E76696469610A2020202020202020202020205D2C205B4D4F44454C2C205B56454E444F522C20274E7669646961275D2C205B545950';
wwv_flow_api.g_varchar2_table(266) := '452C20434F4E534F4C455D5D2C205B0A0A2020202020202020202020202F28706C617973746174696F6E5C735B3334706F727461626C6576695D2B292F6920202020202020202020202020202020202020202020202020202020202020202020202F2F20';
wwv_flow_api.g_varchar2_table(267) := '506C617973746174696F6E0A2020202020202020202020205D2C205B4D4F44454C2C205B56454E444F522C2027536F6E79275D2C205B545950452C20434F4E534F4C455D5D2C205B0A0A2020202020202020202020202F28737072696E745C73285C772B';
wwv_flow_api.g_varchar2_table(268) := '29292F6920202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202F2F20537072696E742050686F6E65730A2020202020202020202020205D2C205B5B56454E444F522C206D617070';
wwv_flow_api.g_varchar2_table(269) := '65722E7374722C206D6170732E6465766963652E737072696E742E76656E646F725D2C205B4D4F44454C2C206D61707065722E7374722C206D6170732E6465766963652E737072696E742E6D6F64656C5D2C205B545950452C204D4F42494C455D5D2C20';
wwv_flow_api.g_varchar2_table(270) := '5B0A0A2020202020202020202020202F286C656E6F766F295C733F2853283F3A353030307C36303030292B283F3A5B2D5D5B5C772B5D29292F69202020202020202020202020202020202020202020202020202F2F204C656E6F766F207461626C657473';
wwv_flow_api.g_varchar2_table(271) := '0A2020202020202020202020205D2C205B56454E444F522C204D4F44454C2C205B545950452C205441424C45545D5D2C205B0A0A2020202020202020202020202F28687463295B3B5F5C732D5D2B285B5C775C735D2B283F3D5C29297C5C772B292A2F69';
wwv_flow_api.g_varchar2_table(272) := '2C202020202020202020202020202020202020202020202020202020202020202F2F204854430A2020202020202020202020202F287A7465292D285C772A292F692C20202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(273) := '202020202020202020202020202020202020202F2F205A54450A2020202020202020202020202F28616C636174656C7C6765656B7370686F6E657C6C656E6F766F7C6E657869616E7C70616E61736F6E69637C283F3D3B5C7329736F6E79295B5F5C732D';
wwv_flow_api.g_varchar2_table(274) := '5D3F285B5C772D5D2A292F690A20202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202F2F20416C6361';
wwv_flow_api.g_varchar2_table(275) := '74656C2F4765656B7350686F6E652F4C656E6F766F2F4E657869616E2F50616E61736F6E69632F536F6E790A2020202020202020202020205D2C205B56454E444F522C205B4D4F44454C2C202F5F2F672C202720275D2C205B545950452C204D4F42494C';
wwv_flow_api.g_varchar2_table(276) := '455D5D2C205B0A0A2020202020202020202020202F286E657875735C7339292F69202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202F2F20485443204E65787573';
wwv_flow_api.g_varchar2_table(277) := '20390A2020202020202020202020205D2C205B4D4F44454C2C205B56454E444F522C2027485443275D2C205B545950452C205441424C45545D5D2C205B0A0A2020202020202020202020202F645C2F687561776569285B5C775C732D5D2B295B3B5C295D';
wwv_flow_api.g_varchar2_table(278) := '2F692C0A2020202020202020202020202F286E657875735C733670292F692020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202F2F204875617765690A202020202020';
wwv_flow_api.g_varchar2_table(279) := '2020202020205D2C205B4D4F44454C2C205B56454E444F522C2027487561776569275D2C205B545950452C204D4F42494C455D5D2C205B0A0A2020202020202020202020202F286D6963726F736F6674293B5C73286C756D69615B5C735C775D2B292F69';
wwv_flow_api.g_varchar2_table(280) := '202020202020202020202020202020202020202020202020202020202020202020202020202F2F204D6963726F736F6674204C756D69610A2020202020202020202020205D2C205B56454E444F522C204D4F44454C2C205B545950452C204D4F42494C45';
wwv_flow_api.g_varchar2_table(281) := '5D5D2C205B0A0A2020202020202020202020202F5B5C735C283B5D2878626F78283F3A5C736F6E65293F295B5C735C293B5D2F6920202020202020202020202020202020202020202020202020202020202020202020202F2F204D6963726F736F667420';
wwv_flow_api.g_varchar2_table(282) := '58626F780A2020202020202020202020205D2C205B4D4F44454C2C205B56454E444F522C20274D6963726F736F6674275D2C205B545950452C20434F4E534F4C455D5D2C205B0A2020202020202020202020202F286B696E5C2E5B6F6E6574775D7B337D';
wwv_flow_api.g_varchar2_table(283) := '292F692020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202F2F204D6963726F736F6674204B696E0A2020202020202020202020205D2C205B5B4D4F44454C2C202F5C2E2F672C2027';
wwv_flow_api.g_varchar2_table(284) := '20275D2C205B56454E444F522C20274D6963726F736F6674275D2C205B545950452C204D4F42494C455D5D2C205B0A0A20202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(285) := '202020202020202020202020202020202020202020202020202020202F2F204D6F746F726F6C610A2020202020202020202020202F5C73286D696C6573746F6E657C64726F6964283F3A5B322D34785D7C5C73283F3A62696F6E69637C78327C70726F7C';
wwv_flow_api.g_varchar2_table(286) := '72617A7229293F3A3F285C733467293F295B5C775C735D2B6275696C645C2F2F692C0A2020202020202020202020202F6D6F745B5C732D5D3F285C772A292F692C0A2020202020202020202020202F2858545C647B332C347D29206275696C645C2F2F69';
wwv_flow_api.g_varchar2_table(287) := '2C0A2020202020202020202020202F286E657875735C7336292F690A2020202020202020202020205D2C205B4D4F44454C2C205B56454E444F522C20274D6F746F726F6C61275D2C205B545950452C204D4F42494C455D5D2C205B0A2020202020202020';
wwv_flow_api.g_varchar2_table(288) := '202020202F616E64726F69642E2B5C73286D7A36305C647C786F6F6D5B5C73325D7B302C327D295C736275696C645C2F2F690A2020202020202020202020205D2C205B4D4F44454C2C205B56454E444F522C20274D6F746F726F6C61275D2C205B545950';
wwv_flow_api.g_varchar2_table(289) := '452C205441424C45545D5D2C205B0A0A2020202020202020202020202F68626274765C2F5C642B5C2E5C642B5C2E5C642B5C732B5C285B5C775C735D2A3B5C732A285C775B5E3B5D2A293B285B5E3B5D2A292F692020202020202020202020202F2F2048';
wwv_flow_api.g_varchar2_table(290) := '6262545620646576696365730A2020202020202020202020205D2C205B5B56454E444F522C207574696C2E7472696D5D2C205B4D4F44454C2C207574696C2E7472696D5D2C205B545950452C20534D41525454565D5D2C205B0A0A202020202020202020';
wwv_flow_api.g_varchar2_table(291) := '2020202F68626274762E2B6D61706C653B285C642B292F690A2020202020202020202020205D2C205B5B4D4F44454C2C202F5E2F2C2027536D6172745456275D2C205B56454E444F522C202753616D73756E67275D2C205B545950452C20534D41525454';
wwv_flow_api.g_varchar2_table(292) := '565D5D2C205B0A0A2020202020202020202020202F5C286474765B5C293B5D2E2B286171756F73292F69202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202F2F2053686172700A202020';
wwv_flow_api.g_varchar2_table(293) := '2020202020202020205D2C205B4D4F44454C2C205B56454E444F522C20275368617270275D2C205B545950452C20534D41525454565D5D2C205B0A0A2020202020202020202020202F616E64726F69642E2B28287363682D695B38395D305C647C736877';
wwv_flow_api.g_varchar2_table(294) := '2D6D333830737C67742D705C647B347D7C67742D6E5C642B7C7367682D74385B35365D397C6E6578757320313029292F692C0A2020202020202020202020202F2828534D2D545C772B29292F690A2020202020202020202020205D2C205B5B56454E444F';
wwv_flow_api.g_varchar2_table(295) := '522C202753616D73756E67275D2C204D4F44454C2C205B545950452C205441424C45545D5D2C205B2020202020202020202020202020202020202F2F2053616D73756E670A2020202020202020202020202F736D6172742D74762E2B2873616D73756E67';
wwv_flow_api.g_varchar2_table(296) := '292F690A2020202020202020202020205D2C205B56454E444F522C205B545950452C20534D41525454565D2C204D4F44454C5D2C205B0A2020202020202020202020202F2828735B6367705D682D5C772B7C67742D5C772B7C67616C6178795C736E6578';
wwv_flow_api.g_varchar2_table(297) := '75737C736D2D5C775B5C775C645D2B29292F692C0A2020202020202020202020202F2873616D5B73756E675D2A295B5C732D5D2A285C772B2D3F5B5C772D5D2A292F692C0A2020202020202020202020202F7365632D28287367685C772B29292F690A20';
wwv_flow_api.g_varchar2_table(298) := '20202020202020202020205D2C205B5B56454E444F522C202753616D73756E67275D2C204D4F44454C2C205B545950452C204D4F42494C455D5D2C205B0A0A2020202020202020202020202F7369652D285C772A292F6920202020202020202020202020';
wwv_flow_api.g_varchar2_table(299) := '202020202020202020202020202020202020202020202020202020202020202020202020202020202020202F2F205369656D656E730A2020202020202020202020205D2C205B4D4F44454C2C205B56454E444F522C20275369656D656E73275D2C205B54';
wwv_flow_api.g_varchar2_table(300) := '5950452C204D4F42494C455D5D2C205B0A0A2020202020202020202020202F286D61656D6F7C6E6F6B6961292E2A286E3930307C6C756D69615C735C642B292F692C20202020202020202020202020202020202020202020202020202020202020202F2F';
wwv_flow_api.g_varchar2_table(301) := '204E6F6B69610A2020202020202020202020202F286E6F6B6961295B5C735F2D5D3F285B5C772D5D2A292F690A2020202020202020202020205D2C205B5B56454E444F522C20274E6F6B6961275D2C204D4F44454C2C205B545950452C204D4F42494C45';
wwv_flow_api.g_varchar2_table(302) := '5D5D2C205B0A0A2020202020202020202020202F616E64726F69645C73335C2E5B5C735C773B2D5D7B31307D28615C647B337D292F692020202020202020202020202020202020202020202020202020202020202020202F2F20416365720A2020202020';
wwv_flow_api.g_varchar2_table(303) := '202020202020205D2C205B4D4F44454C2C205B56454E444F522C202741636572275D2C205B545950452C205441424C45545D5D2C205B0A0A2020202020202020202020202F616E64726F69642E2B285B766C5D6B5C2D3F5C647B337D295C732B6275696C';
wwv_flow_api.g_varchar2_table(304) := '642F692020202020202020202020202020202020202020202020202020202020202020202F2F204C47205461626C65740A2020202020202020202020205D2C205B4D4F44454C2C205B56454E444F522C20274C47275D2C205B545950452C205441424C45';
wwv_flow_api.g_varchar2_table(305) := '545D5D2C205B0A2020202020202020202020202F616E64726F69645C73335C2E5B5C735C773B2D5D7B31307D286C673F292D285B30366376395D7B332C347D292F692020202020202020202020202020202020202020202F2F204C47205461626C65740A';
wwv_flow_api.g_varchar2_table(306) := '2020202020202020202020205D2C205B5B56454E444F522C20274C47275D2C204D4F44454C2C205B545950452C205441424C45545D5D2C205B0A2020202020202020202020202F286C6729206E6574636173745C2E74762F692020202020202020202020';
wwv_flow_api.g_varchar2_table(307) := '20202020202020202020202020202020202020202020202020202020202020202020202020202F2F204C4720536D61727454560A2020202020202020202020205D2C205B56454E444F522C204D4F44454C2C205B545950452C20534D41525454565D5D2C';
wwv_flow_api.g_varchar2_table(308) := '205B0A2020202020202020202020202F286E657875735C735B34355D292F692C2020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202F2F204C470A2020202020202020202020';
wwv_flow_api.g_varchar2_table(309) := '202F6C675B653B5C735C2F2D5D2B285C772A292F692C0A2020202020202020202020202F616E64726F69642E2B6C67285C2D3F5B5C645C775D2B295C732B6275696C642F690A2020202020202020202020205D2C205B4D4F44454C2C205B56454E444F52';
wwv_flow_api.g_varchar2_table(310) := '2C20274C47275D2C205B545950452C204D4F42494C455D5D2C205B0A0A2020202020202020202020202F616E64726F69642E2B28696465617461625B612D7A302D395C2D5C735D2B292F6920202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(311) := '2020202020202020202F2F204C656E6F766F0A2020202020202020202020205D2C205B4D4F44454C2C205B56454E444F522C20274C656E6F766F275D2C205B545950452C205441424C45545D5D2C205B0A0A2020202020202020202020202F6C696E7578';
wwv_flow_api.g_varchar2_table(312) := '3B2E2B28286A6F6C6C6129293B2F6920202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202F2F204A6F6C6C610A2020202020202020202020205D2C205B56454E444F522C204D4F44454C';
wwv_flow_api.g_varchar2_table(313) := '2C205B545950452C204D4F42494C455D5D2C205B0A0A2020202020202020202020202F2828706562626C6529296170705C2F5B5C645C2E5D2B5C732F69202020202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(314) := '20202F2F20506562626C650A2020202020202020202020205D2C205B56454E444F522C204D4F44454C2C205B545950452C205745415241424C455D5D2C205B0A0A2020202020202020202020202F616E64726F69642E2B3B5C73286F70706F295C733F28';
wwv_flow_api.g_varchar2_table(315) := '5B5C775C735D2B295C736275696C642F69202020202020202020202020202020202020202020202020202020202F2F204F50504F0A2020202020202020202020205D2C205B56454E444F522C204D4F44454C2C205B545950452C204D4F42494C455D5D2C';
wwv_flow_api.g_varchar2_table(316) := '205B0A0A2020202020202020202020202F63726B65792F692020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202F2F20476F6F676C65204368726F6D65';
wwv_flow_api.g_varchar2_table(317) := '636173740A2020202020202020202020205D2C205B5B4D4F44454C2C20274368726F6D6563617374275D2C205B56454E444F522C2027476F6F676C65275D5D2C205B0A0A2020202020202020202020202F616E64726F69642E2B3B5C7328676C61737329';
wwv_flow_api.g_varchar2_table(318) := '5C735C642F692020202020202020202020202020202020202020202020202020202020202020202020202020202020202F2F20476F6F676C6520476C6173730A2020202020202020202020205D2C205B4D4F44454C2C205B56454E444F522C2027476F6F';
wwv_flow_api.g_varchar2_table(319) := '676C65275D2C205B545950452C205745415241424C455D5D2C205B0A0A2020202020202020202020202F616E64726F69642E2B3B5C7328706978656C2063295B5C73295D2F69202020202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(320) := '2020202020202020202F2F20476F6F676C6520506978656C20430A2020202020202020202020205D2C205B4D4F44454C2C205B56454E444F522C2027476F6F676C65275D2C205B545950452C205441424C45545D5D2C205B0A0A20202020202020202020';
wwv_flow_api.g_varchar2_table(321) := '20202F616E64726F69642E2B3B5C7328706978656C28205B32335D293F2820786C293F295C732F692020202020202020202020202020202020202020202020202020202020202F2F20476F6F676C6520506978656C0A2020202020202020202020205D2C';
wwv_flow_api.g_varchar2_table(322) := '205B4D4F44454C2C205B56454E444F522C2027476F6F676C65275D2C205B545950452C204D4F42494C455D5D2C205B0A0A2020202020202020202020202F616E64726F69642E2B3B5C73285C772B295C732B6275696C645C2F686D5C312F692C20202020';
wwv_flow_api.g_varchar2_table(323) := '20202020202020202020202020202020202020202020202020202020202F2F205869616F6D6920486F6E676D6920276E756D6572696327206D6F64656C730A2020202020202020202020202F616E64726F69642E2B28686D5B5C735C2D5F5D2A6E6F7465';
wwv_flow_api.g_varchar2_table(324) := '3F5B5C735F5D2A283F3A5C645C77293F295C732B6275696C642F692C2020202020202020202020202020202F2F205869616F6D6920486F6E676D690A2020202020202020202020202F616E64726F69642E2B286D695B5C735C2D5F5D2A283F3A6F6E657C';
wwv_flow_api.g_varchar2_table(325) := '6F6E655B5C735F5D706C75737C6E6F7465206C7465293F5B5C735F5D2A283F3A5C643F5C773F295B5C735F5D2A283F3A706C7573293F295C732B6275696C642F692C202020202F2F205869616F6D69204D690A2020202020202020202020202F616E6472';
wwv_flow_api.g_varchar2_table(326) := '6F69642E2B287265646D695B5C735C2D5F5D2A283F3A6E6F7465293F283F3A5B5C735F5D2A5B5C775C735D2B29295C732B6275696C642F69202020202020202F2F205265646D692050686F6E65730A2020202020202020202020205D2C205B5B4D4F4445';
wwv_flow_api.g_varchar2_table(327) := '4C2C202F5F2F672C202720275D2C205B56454E444F522C20275869616F6D69275D2C205B545950452C204D4F42494C455D5D2C205B0A2020202020202020202020202F616E64726F69642E2B286D695B5C735C2D5F5D2A283F3A70616429283F3A5B5C73';
wwv_flow_api.g_varchar2_table(328) := '5F5D2A5B5C775C735D2B29295C732B6275696C642F692020202020202020202020202F2F204D6920506164207461626C6574730A2020202020202020202020205D2C5B5B4D4F44454C2C202F5F2F672C202720275D2C205B56454E444F522C2027586961';
wwv_flow_api.g_varchar2_table(329) := '6F6D69275D2C205B545950452C205441424C45545D5D2C205B0A2020202020202020202020202F616E64726F69642E2B3B5C73286D5B312D355D5C736E6F7465295C736275696C642F692020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(330) := '2020202020202F2F204D65697A75205461626C65740A2020202020202020202020205D2C205B4D4F44454C2C205B56454E444F522C20274D65697A75275D2C205B545950452C205441424C45545D5D2C205B0A2020202020202020202020202F286D7A29';
wwv_flow_api.g_varchar2_table(331) := '2D285B5C772D5D7B322C7D292F69202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202F2F204D65697A752050686F6E650A2020202020202020202020205D2C205B5B56454E444F';
wwv_flow_api.g_varchar2_table(332) := '522C20274D65697A75275D2C204D4F44454C2C205B545950452C204D4F42494C455D5D2C205B0A0A2020202020202020202020202F616E64726F69642E2B613030302831295C732B6275696C642F692C2020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(333) := '20202020202020202020202020202020202020202F2F204F6E65506C75730A2020202020202020202020202F616E64726F69642E2B6F6E65706C75735C7328615C647B347D295C732B6275696C642F690A2020202020202020202020205D2C205B4D4F44';
wwv_flow_api.g_varchar2_table(334) := '454C2C205B56454E444F522C20274F6E65506C7573275D2C205B545950452C204D4F42494C455D5D2C205B0A0A2020202020202020202020202F616E64726F69642E2B5B3B5C2F5D5C732A285243545B5C645C775D2B295C732B6275696C642F69202020';
wwv_flow_api.g_varchar2_table(335) := '202020202020202020202020202020202020202020202020202F2F20524341205461626C6574730A2020202020202020202020205D2C205B4D4F44454C2C205B56454E444F522C2027524341275D2C205B545950452C205441424C45545D5D2C205B0A0A';
wwv_flow_api.g_varchar2_table(336) := '2020202020202020202020202F616E64726F69642E2B5B3B5C2F5C735D2B2856656E75655B5C645C735D7B322C377D295C732B6275696C642F69202020202020202020202020202020202020202020202F2F2044656C6C2056656E7565205461626C6574';
wwv_flow_api.g_varchar2_table(337) := '730A2020202020202020202020205D2C205B4D4F44454C2C205B56454E444F522C202744656C6C275D2C205B545950452C205441424C45545D5D2C205B0A0A2020202020202020202020202F616E64726F69642E2B5B3B5C2F5D5C732A28515B547C4D5D';
wwv_flow_api.g_varchar2_table(338) := '5B5C645C775D2B295C732B6275696C642F69202020202020202020202020202020202020202020202020202F2F20566572697A6F6E205461626C65740A2020202020202020202020205D2C205B4D4F44454C2C205B56454E444F522C2027566572697A6F';
wwv_flow_api.g_varchar2_table(339) := '6E275D2C205B545950452C205441424C45545D5D2C205B0A0A2020202020202020202020202F616E64726F69642E2B5B3B5C2F5D5C732B284261726E65735B265C735D2B4E6F626C655C732B7C424E5B52545D2928563F2E2A295C732B6275696C642F69';
wwv_flow_api.g_varchar2_table(340) := '20202020202F2F204261726E65732026204E6F626C65205461626C65740A2020202020202020202020205D2C205B5B56454E444F522C20274261726E65732026204E6F626C65275D2C204D4F44454C2C205B545950452C205441424C45545D5D2C205B0A';
wwv_flow_api.g_varchar2_table(341) := '0A2020202020202020202020202F616E64726F69642E2B5B3B5C2F5D5C732B28544D5C647B337D2E2A5C62295C732B6275696C642F692020202020202020202020202020202020202020202020202020202F2F204261726E65732026204E6F626C652054';
wwv_flow_api.g_varchar2_table(342) := '61626C65740A2020202020202020202020205D2C205B4D4F44454C2C205B56454E444F522C20274E75566973696F6E275D2C205B545950452C205441424C45545D5D2C205B0A0A2020202020202020202020202F616E64726F69642E2B3B5C73286B3838';
wwv_flow_api.g_varchar2_table(343) := '295C736275696C642F6920202020202020202020202020202020202020202020202020202020202020202020202020202020202F2F205A5445204B20536572696573205461626C65740A2020202020202020202020205D2C205B4D4F44454C2C205B5645';
wwv_flow_api.g_varchar2_table(344) := '4E444F522C20275A5445275D2C205B545950452C205441424C45545D5D2C205B0A0A2020202020202020202020202F616E64726F69642E2B5B3B5C2F5D5C732A2867656E5C647B337D295C732B6275696C642E2A3439682F692020202020202020202020';
wwv_flow_api.g_varchar2_table(345) := '20202020202020202020202020202F2F2053776973732047454E204D6F62696C650A2020202020202020202020205D2C205B4D4F44454C2C205B56454E444F522C20275377697373275D2C205B545950452C204D4F42494C455D5D2C205B0A0A20202020';
wwv_flow_api.g_varchar2_table(346) := '20202020202020202F616E64726F69642E2B5B3B5C2F5D5C732A287A75725C647B337D295C732B6275696C642F692020202020202020202020202020202020202020202020202020202020202F2F205377697373205A5552205461626C65740A20202020';
wwv_flow_api.g_varchar2_table(347) := '20202020202020205D2C205B4D4F44454C2C205B56454E444F522C20275377697373275D2C205B545950452C205441424C45545D5D2C205B0A0A2020202020202020202020202F616E64726F69642E2B5B3B5C2F5D5C732A28285A656B69293F54422E2A';
wwv_flow_api.g_varchar2_table(348) := '5C62295C732B6275696C642F69202020202020202020202020202020202020202020202020202F2F205A656B69205461626C6574730A2020202020202020202020205D2C205B4D4F44454C2C205B56454E444F522C20275A656B69275D2C205B54595045';
wwv_flow_api.g_varchar2_table(349) := '2C205441424C45545D5D2C205B0A0A2020202020202020202020202F28616E64726F6964292E2B5B3B5C2F5D5C732B285B59525D5C647B327D295C732B6275696C642F692C0A2020202020202020202020202F616E64726F69642E2B5B3B5C2F5D5C732B';
wwv_flow_api.g_varchar2_table(350) := '28447261676F6E5B5C2D5C735D2B546F7563685C732B7C445429285C777B357D295C736275696C642F6920202020202020202F2F20447261676F6E20546F756368205461626C65740A2020202020202020202020205D2C205B5B56454E444F522C202744';
wwv_flow_api.g_varchar2_table(351) := '7261676F6E20546F756368275D2C204D4F44454C2C205B545950452C205441424C45545D5D2C205B0A0A2020202020202020202020202F616E64726F69642E2B5B3B5C2F5D5C732A284E532D3F5C777B302C397D295C736275696C642F69202020202020';
wwv_flow_api.g_varchar2_table(352) := '202020202020202020202020202020202020202020202F2F20496E7369676E6961205461626C6574730A2020202020202020202020205D2C205B4D4F44454C2C205B56454E444F522C2027496E7369676E6961275D2C205B545950452C205441424C4554';
wwv_flow_api.g_varchar2_table(353) := '5D5D2C205B0A0A2020202020202020202020202F616E64726F69642E2B5B3B5C2F5D5C732A28284E587C4E657874292D3F5C777B302C397D295C732B6275696C642F6920202020202020202020202020202020202020202F2F204E657874426F6F6B2054';
wwv_flow_api.g_varchar2_table(354) := '61626C6574730A2020202020202020202020205D2C205B4D4F44454C2C205B56454E444F522C20274E657874426F6F6B275D2C205B545950452C205441424C45545D5D2C205B0A0A2020202020202020202020202F616E64726F69642E2B5B3B5C2F5D5C';
wwv_flow_api.g_varchar2_table(355) := '732A28587472656D655C5F293F285628315B3034355D7C325B3031355D7C33307C34307C36307C375B30355D7C393029295C732B6275696C642F690A2020202020202020202020205D2C205B5B56454E444F522C2027566F696365275D2C204D4F44454C';
wwv_flow_api.g_varchar2_table(356) := '2C205B545950452C204D4F42494C455D5D2C205B20202020202020202020202020202020202020202F2F20566F69636520587472656D652050686F6E65730A0A2020202020202020202020202F616E64726F69642E2B5B3B5C2F5D5C732A284C5654454C';
wwv_flow_api.g_varchar2_table(357) := '5C2D293F2856315B31325D295C732B6275696C642F692020202020202020202020202020202020202020202F2F204C7654656C2050686F6E65730A2020202020202020202020205D2C205B5B56454E444F522C20274C7654656C275D2C204D4F44454C2C';
wwv_flow_api.g_varchar2_table(358) := '205B545950452C204D4F42494C455D5D2C205B0A0A2020202020202020202020202F616E64726F69642E2B3B5C732850482D31295C732F690A2020202020202020202020205D2C205B4D4F44454C2C205B56454E444F522C2027457373656E7469616C27';
wwv_flow_api.g_varchar2_table(359) := '5D2C205B545950452C204D4F42494C455D5D2C205B202020202020202020202020202020202F2F20457373656E7469616C2050482D310A0A2020202020202020202020202F616E64726F69642E2B5B3B5C2F5D5C732A2856283130304D447C3730304E41';
wwv_flow_api.g_varchar2_table(360) := '7C373031317C39313747292E2A5C62295C732B6275696C642F69202020202020202020202F2F20456E76697A656E205461626C6574730A2020202020202020202020205D2C205B4D4F44454C2C205B56454E444F522C2027456E76697A656E275D2C205B';
wwv_flow_api.g_varchar2_table(361) := '545950452C205441424C45545D5D2C205B0A0A2020202020202020202020202F616E64726F69642E2B5B3B5C2F5D5C732A284C655B5C735C2D5D2B50616E295B5C735C2D5D2B285C777B312C397D295C732B6275696C642F69202020202020202020202F';
wwv_flow_api.g_varchar2_table(362) := '2F204C652050616E205461626C6574730A2020202020202020202020205D2C205B56454E444F522C204D4F44454C2C205B545950452C205441424C45545D5D2C205B0A0A2020202020202020202020202F616E64726F69642E2B5B3B5C2F5D5C732A2854';
wwv_flow_api.g_varchar2_table(363) := '72696F5B5C735C2D5D2A2E2A295C732B6275696C642F69202020202020202020202020202020202020202020202020202F2F204D6163685370656564205461626C6574730A2020202020202020202020205D2C205B4D4F44454C2C205B56454E444F522C';
wwv_flow_api.g_varchar2_table(364) := '20274D6163685370656564275D2C205B545950452C205441424C45545D5D2C205B0A0A2020202020202020202020202F616E64726F69642E2B5B3B5C2F5D5C732A285472696E697479295B5C2D5C735D2A28545C647B337D295C732B6275696C642F6920';
wwv_flow_api.g_varchar2_table(365) := '2020202020202020202020202020202F2F205472696E697479205461626C6574730A2020202020202020202020205D2C205B56454E444F522C204D4F44454C2C205B545950452C205441424C45545D5D2C205B0A0A2020202020202020202020202F616E';
wwv_flow_api.g_varchar2_table(366) := '64726F69642E2B5B3B5C2F5D5C732A54555F2831343931295C732B6275696C642F69202020202020202020202020202020202020202020202020202020202020202F2F20526F746F72205461626C6574730A2020202020202020202020205D2C205B4D4F';
wwv_flow_api.g_varchar2_table(367) := '44454C2C205B56454E444F522C2027526F746F72275D2C205B545950452C205441424C45545D5D2C205B0A0A2020202020202020202020202F616E64726F69642E2B284B53282E2B29295C732B6275696C642F6920202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(368) := '2020202020202020202020202020202020202020202020202F2F20416D617A6F6E204B696E646C65205461626C6574730A2020202020202020202020205D2C205B4D4F44454C2C205B56454E444F522C2027416D617A6F6E275D2C205B545950452C2054';
wwv_flow_api.g_varchar2_table(369) := '41424C45545D5D2C205B0A0A2020202020202020202020202F616E64726F69642E2B2847696761736574295B5C735C2D5D2B28515C777B312C397D295C732B6275696C642F69202020202020202020202020202020202020202020202F2F204769676173';
wwv_flow_api.g_varchar2_table(370) := '6574205461626C6574730A2020202020202020202020205D2C205B56454E444F522C204D4F44454C2C205B545950452C205441424C45545D5D2C205B0A0A2020202020202020202020202F5C73287461626C65747C746162295B3B5C2F5D2F692C202020';
wwv_flow_api.g_varchar2_table(371) := '2020202020202020202020202020202020202020202020202020202020202020202020202020202020202F2F20556E6964656E7469666961626C65205461626C65740A2020202020202020202020202F5C73286D6F62696C6529283F3A5B3B5C2F5D7C5C';
wwv_flow_api.g_varchar2_table(372) := '73736166617269292F69202020202020202020202020202020202020202020202020202020202020202020202020202F2F20556E6964656E7469666961626C65204D6F62696C650A2020202020202020202020205D2C205B5B545950452C207574696C2E';
wwv_flow_api.g_varchar2_table(373) := '6C6F776572697A655D2C2056454E444F522C204D4F44454C5D2C205B0A0A2020202020202020202020202F28616E64726F69645B5C775C2E5C735C2D5D7B302C397D293B2E2B6275696C642F692020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(374) := '202020202020202020202F2F2047656E6572696320416E64726F6964204465766963650A2020202020202020202020205D2C205B4D4F44454C2C205B56454E444F522C202747656E65726963275D5D0A0A0A20202020202020202F2A2F2F2F2F2F2F2F2F';
wwv_flow_api.g_varchar2_table(375) := '2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F0A2020202020202020202020202F2F20544F444F3A206D6F766520746F20737472696E67206D61700A2020202020202020202020202F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F0A';
wwv_flow_api.g_varchar2_table(376) := '0A2020202020202020202020202F284336363033292F69202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202F2F20536F6E7920587065726961205A204336';
wwv_flow_api.g_varchar2_table(377) := '3630330A2020202020202020202020205D2C205B5B4D4F44454C2C2027587065726961205A204336363033275D2C205B56454E444F522C2027536F6E79275D2C205B545950452C204D4F42494C455D5D2C205B0A2020202020202020202020202F284336';
wwv_flow_api.g_varchar2_table(378) := '393033292F69202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202F2F20536F6E7920587065726961205A20310A2020202020202020202020205D2C205B5B';
wwv_flow_api.g_varchar2_table(379) := '4D4F44454C2C2027587065726961205A2031275D2C205B56454E444F522C2027536F6E79275D2C205B545950452C204D4F42494C455D5D2C205B0A0A2020202020202020202020202F28534D2D473930305B467C485D292F692020202020202020202020';
wwv_flow_api.g_varchar2_table(380) := '202020202020202020202020202020202020202020202020202020202020202020202020202020202F2F2053616D73756E672047616C6178792053350A2020202020202020202020205D2C205B5B4D4F44454C2C202747616C617879205335275D2C205B';
wwv_flow_api.g_varchar2_table(381) := '56454E444F522C202753616D73756E67275D2C205B545950452C204D4F42494C455D5D2C205B0A2020202020202020202020202F28534D2D4737313032292F69202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(382) := '202020202020202020202020202020202020202F2F2053616D73756E672047616C617879204772616E6420320A2020202020202020202020205D2C205B5B4D4F44454C2C202747616C617879204772616E642032275D2C205B56454E444F522C20275361';
wwv_flow_api.g_varchar2_table(383) := '6D73756E67275D2C205B545950452C204D4F42494C455D5D2C205B0A2020202020202020202020202F28534D2D4735333048292F692020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(384) := '20202020202020202F2F2053616D73756E672047616C617879204772616E64205072696D650A2020202020202020202020205D2C205B5B4D4F44454C2C202747616C617879204772616E64205072696D65275D2C205B56454E444F522C202753616D7375';
wwv_flow_api.g_varchar2_table(385) := '6E67275D2C205B545950452C204D4F42494C455D5D2C205B0A2020202020202020202020202F28534D2D47333133485A292F6920202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(386) := '20202020202F2F2053616D73756E672047616C61787920560A2020202020202020202020205D2C205B5B4D4F44454C2C202747616C6178792056275D2C205B56454E444F522C202753616D73756E67275D2C205B545950452C204D4F42494C455D5D2C20';
wwv_flow_api.g_varchar2_table(387) := '5B0A2020202020202020202020202F28534D2D54383035292F6920202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202F2F2053616D73756E672047616C61787920';
wwv_flow_api.g_varchar2_table(388) := '54616220532031302E350A2020202020202020202020205D2C205B5B4D4F44454C2C202747616C6178792054616220532031302E35275D2C205B56454E444F522C202753616D73756E67275D2C205B545950452C205441424C45545D5D2C205B0A202020';
wwv_flow_api.g_varchar2_table(389) := '2020202020202020202F28534D2D4738303046292F69202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202F2F2053616D73756E672047616C617879205335204D69';
wwv_flow_api.g_varchar2_table(390) := '6E690A2020202020202020202020205D2C205B5B4D4F44454C2C202747616C617879205335204D696E69275D2C205B56454E444F522C202753616D73756E67275D2C205B545950452C204D4F42494C455D5D2C205B0A2020202020202020202020202F28';
wwv_flow_api.g_varchar2_table(391) := '534D2D54333131292F6920202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202F2F2053616D73756E672047616C61787920546162203320382E300A202020202020';
wwv_flow_api.g_varchar2_table(392) := '2020202020205D2C205B5B4D4F44454C2C202747616C61787920546162203320382E30275D2C205B56454E444F522C202753616D73756E67275D2C205B545950452C205441424C45545D5D2C205B0A0A2020202020202020202020202F28543343292F69';
wwv_flow_api.g_varchar2_table(393) := '2020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202F2F20416476616E2056616E64726F6964205433430A2020202020202020202020205D2C205B4D4F';
wwv_flow_api.g_varchar2_table(394) := '44454C2C205B56454E444F522C2027416476616E275D2C205B545950452C205441424C45545D5D2C205B0A2020202020202020202020202F28414456414E2054314A5C2B292F692020202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(395) := '20202020202020202020202020202020202020202020202F2F20416476616E2056616E64726F69642054314A2B0A2020202020202020202020205D2C205B5B4D4F44454C2C202756616E64726F69642054314A2B275D2C205B56454E444F522C20274164';
wwv_flow_api.g_varchar2_table(396) := '76616E275D2C205B545950452C205441424C45545D5D2C205B0A2020202020202020202020202F28414456414E20533441292F69202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(397) := '2020202020202F2F20416476616E2056616E64726F6964205334410A2020202020202020202020205D2C205B5B4D4F44454C2C202756616E64726F696420533441275D2C205B56454E444F522C2027416476616E275D2C205B545950452C204D4F42494C';
wwv_flow_api.g_varchar2_table(398) := '455D5D2C205B0A0A2020202020202020202020202F28563937324D292F69202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202F2F205A544520563937324D';
wwv_flow_api.g_varchar2_table(399) := '0A2020202020202020202020205D2C205B4D4F44454C2C205B56454E444F522C20275A5445275D2C205B545950452C204D4F42494C455D5D2C205B0A0A2020202020202020202020202F28692D6D6F62696C65295C732849515C735B5C645C2E5D2B292F';
wwv_flow_api.g_varchar2_table(400) := '69202020202020202020202020202020202020202020202020202020202020202020202020202020202F2F20692D6D6F62696C652049510A2020202020202020202020205D2C205B56454E444F522C204D4F44454C2C205B545950452C204D4F42494C45';
wwv_flow_api.g_varchar2_table(401) := '5D5D2C205B0A2020202020202020202020202F284951362E33292F69202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202F2F20692D6D6F62696C65204951';
wwv_flow_api.g_varchar2_table(402) := '20495120362E330A2020202020202020202020205D2C205B5B4D4F44454C2C2027495120362E33275D2C205B56454E444F522C2027692D6D6F62696C65275D2C205B545950452C204D4F42494C455D5D2C205B0A2020202020202020202020202F28692D';
wwv_flow_api.g_varchar2_table(403) := '6D6F62696C65295C7328692D7374796C655C735B5C645C2E5D2B292F6920202020202020202020202020202020202020202020202020202020202020202020202F2F20692D6D6F62696C6520692D5354594C450A2020202020202020202020205D2C205B';
wwv_flow_api.g_varchar2_table(404) := '56454E444F522C204D4F44454C2C205B545950452C204D4F42494C455D5D2C205B0A2020202020202020202020202F28692D5354594C45322E31292F69202020202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(405) := '20202020202020202020202020202F2F20692D6D6F62696C6520692D5354594C4520322E310A2020202020202020202020205D2C205B5B4D4F44454C2C2027692D5354594C4520322E31275D2C205B56454E444F522C2027692D6D6F62696C65275D2C20';
wwv_flow_api.g_varchar2_table(406) := '5B545950452C204D4F42494C455D5D2C205B0A0A2020202020202020202020202F286D6F6269697374617220746F756368204C414920353132292F6920202020202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(407) := '2F2F206D6F6269697374617220746F756368204C4149203531320A2020202020202020202020205D2C205B5B4D4F44454C2C2027546F756368204C414920353132275D2C205B56454E444F522C20276D6F62696973746172275D2C205B545950452C204D';
wwv_flow_api.g_varchar2_table(408) := '4F42494C455D5D2C205B0A0A2020202020202020202020202F2F2F2F2F2F2F2F2F2F2F2F2F0A2020202020202020202020202F2F20454E4420544F444F0A2020202020202020202020202F2F2F2F2F2F2F2F2F2F2F2A2F0A0A20202020202020205D2C0A';
wwv_flow_api.g_varchar2_table(409) := '0A2020202020202020656E67696E65203A205B5B0A0A2020202020202020202020202F77696E646F77732E2B5C73656467655C2F285B5C775C2E5D2B292F6920202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(410) := '20202F2F204564676548544D4C0A2020202020202020202020205D2C205B56455253494F4E2C205B4E414D452C20274564676548544D4C275D5D2C205B0A0A2020202020202020202020202F2870726573746F295C2F285B5C775C2E5D2B292F692C2020';
wwv_flow_api.g_varchar2_table(411) := '202020202020202020202020202020202020202020202020202020202020202020202020202020202020202F2F2050726573746F0A2020202020202020202020202F287765626B69747C74726964656E747C6E657466726F6E747C6E6574737572667C61';
wwv_flow_api.g_varchar2_table(412) := '6D6179617C6C796E787C77336D295C2F285B5C775C2E5D2B292F692C20202020202F2F205765624B69742F54726964656E742F4E657446726F6E742F4E6574537572662F416D6179612F4C796E782F77336D0A2020202020202020202020202F286B6874';
wwv_flow_api.g_varchar2_table(413) := '6D6C7C7461736D616E7C6C696E6B73295B5C2F5C735D5C283F285B5C775C2E5D2B292F692C20202020202020202020202020202020202020202020202020202F2F204B48544D4C2F5461736D616E2F4C696E6B730A2020202020202020202020202F2869';
wwv_flow_api.g_varchar2_table(414) := '636162295B5C2F5C735D285B32335D5C2E5B5C645C2E5D2B292F6920202020202020202020202020202020202020202020202020202020202020202020202020202F2F20694361620A2020202020202020202020205D2C205B4E414D452C205645525349';
wwv_flow_api.g_varchar2_table(415) := '4F4E5D2C205B0A0A2020202020202020202020202F72765C3A285B5C775C2E5D7B312C397D292E2B286765636B6F292F692020202020202020202020202020202020202020202020202020202020202020202020202020202F2F204765636B6F0A202020';
wwv_flow_api.g_varchar2_table(416) := '2020202020202020205D2C205B56455253494F4E2C204E414D455D0A20202020202020205D2C0A0A20202020202020206F73203A205B5B0A0A2020202020202020202020202F2F2057696E646F77732062617365640A2020202020202020202020202F6D';
wwv_flow_api.g_varchar2_table(417) := '6963726F736F66745C732877696E646F7773295C732876697374617C7870292F692020202020202020202020202020202020202020202020202020202020202020202F2F2057696E646F777320286954756E6573290A2020202020202020202020205D2C';
wwv_flow_api.g_varchar2_table(418) := '205B4E414D452C2056455253494F4E5D2C205B0A2020202020202020202020202F2877696E646F7773295C736E745C73365C2E323B5C732861726D292F692C20202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(419) := '2F2F2057696E646F77732052540A2020202020202020202020202F2877696E646F77735C7370686F6E65283F3A5C736F73292A295B5C735C2F5D3F285B5C645C2E5C735C775D2A292F692C202020202020202020202020202020202020202F2F2057696E';
wwv_flow_api.g_varchar2_table(420) := '646F77732050686F6E650A2020202020202020202020202F2877696E646F77735C736D6F62696C657C77696E646F7773295B5C735C2F5D3F285B6E7463655C645C2E5C735D2B5C77292F690A2020202020202020202020205D2C205B4E414D452C205B56';
wwv_flow_api.g_varchar2_table(421) := '455253494F4E2C206D61707065722E7374722C206D6170732E6F732E77696E646F77732E76657273696F6E5D5D2C205B0A2020202020202020202020202F2877696E283F3D337C397C6E297C77696E5C7339785C7329285B6E745C645C2E5D2B292F690A';
wwv_flow_api.g_varchar2_table(422) := '2020202020202020202020205D2C205B5B4E414D452C202757696E646F7773275D2C205B56455253494F4E2C206D61707065722E7374722C206D6170732E6F732E77696E646F77732E76657273696F6E5D5D2C205B0A0A2020202020202020202020202F';
wwv_flow_api.g_varchar2_table(423) := '2F204D6F62696C652F456D626564646564204F530A2020202020202020202020202F5C2828626229283130293B2F692020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(424) := '202F2F20426C61636B42657272792031300A2020202020202020202020205D2C205B5B4E414D452C2027426C61636B4265727279275D2C2056455253494F4E5D2C205B0A2020202020202020202020202F28626C61636B6265727279295C772A5C2F3F28';
wwv_flow_api.g_varchar2_table(425) := '5B5C775C2E5D2A292F692C202020202020202020202020202020202020202020202020202020202020202020202020202F2F20426C61636B62657272790A2020202020202020202020202F2874697A656E295B5C2F5C735D285B5C775C2E5D2B292F692C';
wwv_flow_api.g_varchar2_table(426) := '2020202020202020202020202020202020202020202020202020202020202020202020202020202020202F2F2054697A656E0A2020202020202020202020202F28616E64726F69647C7765626F737C70616C6D5C736F737C716E787C626164617C72696D';
wwv_flow_api.g_varchar2_table(427) := '5C737461626C65745C736F737C6D6565676F7C636F6E74696B69295B5C2F5C732D5D3F285B5C775C2E5D2A292F692C0A20202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(428) := '202020202020202020202020202020202020202020202020202020202F2F20416E64726F69642F5765624F532F50616C6D2F514E582F426164612F52494D2F4D6565476F2F436F6E74696B690A2020202020202020202020202F6C696E75783B2E2B2873';
wwv_flow_api.g_varchar2_table(429) := '61696C66697368293B2F69202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202F2F205361696C66697368204F530A2020202020202020202020205D2C205B4E414D452C2056455253494F';
wwv_flow_api.g_varchar2_table(430) := '4E5D2C205B0A2020202020202020202020202F2873796D6269616E5C733F6F737C73796D626F737C733630283F3D3B29295B5C2F5C732D5D3F285B5C775C2E5D2A292F692020202020202020202020202020202020202F2F2053796D6269616E0A202020';
wwv_flow_api.g_varchar2_table(431) := '2020202020202020205D2C205B5B4E414D452C202753796D6269616E275D2C2056455253494F4E5D2C205B0A2020202020202020202020202F5C28287365726965733430293B2F6920202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(432) := '2020202020202020202020202020202020202020202020202F2F205365726965732034300A2020202020202020202020205D2C205B4E414D455D2C205B0A2020202020202020202020202F6D6F7A696C6C612E2B5C286D6F62696C653B2E2B6765636B6F';
wwv_flow_api.g_varchar2_table(433) := '2E2B66697265666F782F69202020202020202020202020202020202020202020202020202020202020202F2F2046697265666F78204F530A2020202020202020202020205D2C205B5B4E414D452C202746697265666F78204F53275D2C2056455253494F';
wwv_flow_api.g_varchar2_table(434) := '4E5D2C205B0A0A2020202020202020202020202F2F20436F6E736F6C650A2020202020202020202020202F286E696E74656E646F7C706C617973746174696F6E295C73285B776964733334706F727461626C6576755D2B292F692C202020202020202020';
wwv_flow_api.g_varchar2_table(435) := '202020202020202020202F2F204E696E74656E646F2F506C617973746174696F6E0A0A2020202020202020202020202F2F20474E552F4C696E75782062617365640A2020202020202020202020202F286D696E74295B5C2F5C735C285D3F285C772A292F';
wwv_flow_api.g_varchar2_table(436) := '692C20202020202020202020202020202020202020202020202020202020202020202020202020202020202020202F2F204D696E740A2020202020202020202020202F286D61676569617C766563746F726C696E7578295B3B5C735D2F692C2020202020';
wwv_flow_api.g_varchar2_table(437) := '202020202020202020202020202020202020202020202020202020202020202020202F2F204D61676569612F566563746F724C696E75780A2020202020202020202020202F286A6F6C697C5B6B786C6E5D3F7562756E74757C64656269616E7C73757365';
wwv_flow_api.g_varchar2_table(438) := '7C6F70656E737573657C67656E746F6F7C283F3D5C7329617263687C736C61636B776172657C6665646F72617C6D616E64726976617C63656E746F737C70636C696E75786F737C7265646861747C7A656E77616C6B7C6C696E707573295B5C2F5C732D5D';
wwv_flow_api.g_varchar2_table(439) := '3F283F216368726F6D29285B5C775C2E2D5D2A292F692C0A20202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(440) := '202020202F2F204A6F6C692F5562756E74752F44656269616E2F535553452F47656E746F6F2F417263682F536C61636B776172650A2020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(441) := '2020202020202020202020202020202020202020202020202020202020202020202F2F204665646F72612F4D616E64726976612F43656E744F532F50434C696E75784F532F5265644861742F5A656E77616C6B2F4C696E7075730A202020202020202020';
wwv_flow_api.g_varchar2_table(442) := '2020202F28687572647C6C696E7578295C733F285B5C775C2E5D2A292F692C202020202020202020202020202020202020202020202020202020202020202020202020202020202F2F20487572642F4C696E75780A2020202020202020202020202F2867';
wwv_flow_api.g_varchar2_table(443) := '6E75295C733F285B5C775C2E5D2A292F692020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202F2F20474E550A2020202020202020202020205D2C205B4E414D452C2056455253494F';
wwv_flow_api.g_varchar2_table(444) := '4E5D2C205B0A0A2020202020202020202020202F2863726F73295C735B5C775D2B5C73285B5C775C2E5D2B5C77292F692020202020202020202020202020202020202020202020202020202020202020202020202020202F2F204368726F6D69756D204F';
wwv_flow_api.g_varchar2_table(445) := '530A2020202020202020202020205D2C205B5B4E414D452C20274368726F6D69756D204F53275D2C2056455253494F4E5D2C5B0A0A2020202020202020202020202F2F20536F6C617269730A2020202020202020202020202F2873756E6F73295C733F28';
wwv_flow_api.g_varchar2_table(446) := '5B5C775C2E5C645D2A292F6920202020202020202020202020202020202020202020202020202020202020202020202020202020202020202F2F20536F6C617269730A2020202020202020202020205D2C205B5B4E414D452C2027536F6C61726973275D';
wwv_flow_api.g_varchar2_table(447) := '2C2056455253494F4E5D2C205B0A0A2020202020202020202020202F2F204253442062617365640A2020202020202020202020202F5C73285B6672656E746F70632D5D7B302C347D6273647C647261676F6E666C79295C733F285B5C775C2E5D2A292F69';
wwv_flow_api.g_varchar2_table(448) := '20202020202020202020202020202020202020202F2F20467265654253442F4E65744253442F4F70656E4253442F50432D4253442F447261676F6E466C790A2020202020202020202020205D2C205B4E414D452C2056455253494F4E5D2C5B0A0A202020';
wwv_flow_api.g_varchar2_table(449) := '2020202020202020202F286861696B75295C73285C772B292F692020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202F2F204861696B750A2020202020202020202020205D2C';
wwv_flow_api.g_varchar2_table(450) := '205B4E414D452C2056455253494F4E5D2C5B0A0A2020202020202020202020202F63666E6574776F726B5C2F2E2B64617277696E2F692C0A2020202020202020202020202F69705B686F6E6561645D7B322C347D283F3A2E2A6F735C73285B5C775D2B29';
wwv_flow_api.g_varchar2_table(451) := '5C736C696B655C736D61637C3B5C736F70657261292F69202020202020202020202020202F2F20694F530A2020202020202020202020205D2C205B5B56455253494F4E2C202F5F2F672C20272E275D2C205B4E414D452C2027694F53275D5D2C205B0A0A';
wwv_flow_api.g_varchar2_table(452) := '2020202020202020202020202F286D61635C736F735C7378295C733F285B5C775C735C2E5D2A292F692C0A2020202020202020202020202F286D6163696E746F73687C6D6163283F3D5F706F7765727063295C73292F6920202020202020202020202020';
wwv_flow_api.g_varchar2_table(453) := '20202020202020202020202020202020202020202020202F2F204D6163204F530A2020202020202020202020205D2C205B5B4E414D452C20274D6163204F53275D2C205B56455253494F4E2C202F5F2F672C20272E275D5D2C205B0A0A20202020202020';
wwv_flow_api.g_varchar2_table(454) := '20202020202F2F204F746865720A2020202020202020202020202F28283F3A6F70656E293F736F6C61726973295B5C2F5C732D5D3F285B5C775C2E5D2A292F692C20202020202020202020202020202020202020202020202020202020202F2F20536F6C';
wwv_flow_api.g_varchar2_table(455) := '617269730A2020202020202020202020202F28616978295C7328285C6429283F3D5C2E7C5C297C5C73295B5C775C2E5D292A2F692C20202020202020202020202020202020202020202020202020202020202020202F2F204149580A2020202020202020';
wwv_flow_api.g_varchar2_table(456) := '202020202F28706C616E5C73397C6D696E69787C62656F737C6F735C2F327C616D6967616F737C6D6F7270686F737C726973635C736F737C6F70656E766D737C66756368736961292F692C0A202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(457) := '20202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202F2F20506C616E392F4D696E69782F42654F532F4F53322F416D6967614F532F4D6F7270684F532F52495343';
wwv_flow_api.g_varchar2_table(458) := '4F532F4F70656E564D532F467563687369610A2020202020202020202020202F28756E6978295C733F285B5C775C2E5D2A292F6920202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202F';
wwv_flow_api.g_varchar2_table(459) := '2F20554E49580A2020202020202020202020205D2C205B4E414D452C2056455253494F4E5D0A20202020202020205D0A202020207D3B0A0A0A202020202F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F0A202020202F2F20436F6E7374727563746F720A2020';
wwv_flow_api.g_varchar2_table(460) := '20202F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F0A202020202F2A0A202020207661722042726F77736572203D2066756E6374696F6E20286E616D652C2076657273696F6E29207B0A2020202020202020746869735B4E414D455D203D206E616D653B0A2020';
wwv_flow_api.g_varchar2_table(461) := '202020202020746869735B56455253494F4E5D203D2076657273696F6E3B0A202020207D3B0A2020202076617220435055203D2066756E6374696F6E20286172636829207B0A2020202020202020746869735B4152434849544543545552455D203D2061';
wwv_flow_api.g_varchar2_table(462) := '7263683B0A202020207D3B0A2020202076617220446576696365203D2066756E6374696F6E202876656E646F722C206D6F64656C2C207479706529207B0A2020202020202020746869735B56454E444F525D203D2076656E646F723B0A20202020202020';
wwv_flow_api.g_varchar2_table(463) := '20746869735B4D4F44454C5D203D206D6F64656C3B0A2020202020202020746869735B545950455D203D20747970653B0A202020207D3B0A2020202076617220456E67696E65203D2042726F777365723B0A20202020766172204F53203D2042726F7773';
wwv_flow_api.g_varchar2_table(464) := '65723B0A202020202A2F0A20202020766172205541506172736572203D2066756E6374696F6E20287561737472696E672C20657874656E73696F6E7329207B0A0A202020202020202069662028747970656F66207561737472696E67203D3D3D20276F62';
wwv_flow_api.g_varchar2_table(465) := '6A6563742729207B0A202020202020202020202020657874656E73696F6E73203D207561737472696E673B0A2020202020202020202020207561737472696E67203D20756E646566696E65643B0A20202020202020207D0A0A2020202020202020696620';
wwv_flow_api.g_varchar2_table(466) := '2821287468697320696E7374616E63656F662055415061727365722929207B0A20202020202020202020202072657475726E206E6577205541506172736572287561737472696E672C20657874656E73696F6E73292E676574526573756C7428293B0A20';
wwv_flow_api.g_varchar2_table(467) := '202020202020207D0A0A2020202020202020766172207561203D207561737472696E67207C7C20282877696E646F772026262077696E646F772E6E6176696761746F722026262077696E646F772E6E6176696761746F722E757365724167656E7429203F';
wwv_flow_api.g_varchar2_table(468) := '2077696E646F772E6E6176696761746F722E757365724167656E74203A20454D505459293B0A2020202020202020766172207267786D6170203D20657874656E73696F6E73203F207574696C2E657874656E6428726567657865732C20657874656E7369';
wwv_flow_api.g_varchar2_table(469) := '6F6E7329203A20726567657865733B0A20202020202020202F2F7661722062726F77736572203D206E65772042726F7773657228293B0A20202020202020202F2F76617220637075203D206E65772043505528293B0A20202020202020202F2F76617220';
wwv_flow_api.g_varchar2_table(470) := '646576696365203D206E65772044657669636528293B0A20202020202020202F2F76617220656E67696E65203D206E657720456E67696E6528293B0A20202020202020202F2F766172206F73203D206E6577204F5328293B0A0A20202020202020207468';
wwv_flow_api.g_varchar2_table(471) := '69732E67657442726F77736572203D2066756E6374696F6E202829207B0A2020202020202020202020207661722062726F77736572203D207B206E616D653A20756E646566696E65642C2076657273696F6E3A20756E646566696E6564207D3B0A202020';
wwv_flow_api.g_varchar2_table(472) := '2020202020202020206D61707065722E7267782E63616C6C2862726F777365722C2075612C207267786D61702E62726F77736572293B0A20202020202020202020202062726F777365722E6D616A6F72203D207574696C2E6D616A6F722862726F777365';
wwv_flow_api.g_varchar2_table(473) := '722E76657273696F6E293B202F2F20646570726563617465640A20202020202020202020202072657475726E2062726F777365723B0A20202020202020207D3B0A2020202020202020746869732E676574435055203D2066756E6374696F6E202829207B';
wwv_flow_api.g_varchar2_table(474) := '0A20202020202020202020202076617220637075203D207B206172636869746563747572653A20756E646566696E6564207D3B0A2020202020202020202020206D61707065722E7267782E63616C6C286370752C2075612C207267786D61702E63707529';
wwv_flow_api.g_varchar2_table(475) := '3B0A20202020202020202020202072657475726E206370753B0A20202020202020207D3B0A2020202020202020746869732E676574446576696365203D2066756E6374696F6E202829207B0A20202020202020202020202076617220646576696365203D';
wwv_flow_api.g_varchar2_table(476) := '207B2076656E646F723A20756E646566696E65642C206D6F64656C3A20756E646566696E65642C20747970653A20756E646566696E6564207D3B0A2020202020202020202020206D61707065722E7267782E63616C6C286465766963652C2075612C2072';
wwv_flow_api.g_varchar2_table(477) := '67786D61702E646576696365293B0A20202020202020202020202072657475726E206465766963653B0A20202020202020207D3B0A2020202020202020746869732E676574456E67696E65203D2066756E6374696F6E202829207B0A2020202020202020';
wwv_flow_api.g_varchar2_table(478) := '2020202076617220656E67696E65203D207B206E616D653A20756E646566696E65642C2076657273696F6E3A20756E646566696E6564207D3B0A2020202020202020202020206D61707065722E7267782E63616C6C28656E67696E652C2075612C207267';
wwv_flow_api.g_varchar2_table(479) := '786D61702E656E67696E65293B0A20202020202020202020202072657475726E20656E67696E653B0A20202020202020207D3B0A2020202020202020746869732E6765744F53203D2066756E6374696F6E202829207B0A20202020202020202020202076';
wwv_flow_api.g_varchar2_table(480) := '6172206F73203D207B206E616D653A20756E646566696E65642C2076657273696F6E3A20756E646566696E6564207D3B0A2020202020202020202020206D61707065722E7267782E63616C6C286F732C2075612C207267786D61702E6F73293B0A202020';
wwv_flow_api.g_varchar2_table(481) := '20202020202020202072657475726E206F733B0A20202020202020207D3B0A2020202020202020746869732E676574526573756C74203D2066756E6374696F6E202829207B0A20202020202020202020202072657475726E207B0A202020202020202020';
wwv_flow_api.g_varchar2_table(482) := '2020202020202075612020202020203A20746869732E676574554128292C0A2020202020202020202020202020202062726F77736572203A20746869732E67657442726F7773657228292C0A20202020202020202020202020202020656E67696E652020';
wwv_flow_api.g_varchar2_table(483) := '3A20746869732E676574456E67696E6528292C0A202020202020202020202020202020206F732020202020203A20746869732E6765744F5328292C0A2020202020202020202020202020202064657669636520203A20746869732E676574446576696365';
wwv_flow_api.g_varchar2_table(484) := '28292C0A2020202020202020202020202020202063707520202020203A20746869732E67657443505528290A2020202020202020202020207D3B0A20202020202020207D3B0A2020202020202020746869732E6765745541203D2066756E6374696F6E20';
wwv_flow_api.g_varchar2_table(485) := '2829207B0A20202020202020202020202072657475726E2075613B0A20202020202020207D3B0A2020202020202020746869732E7365745541203D2066756E6374696F6E20287561737472696E6729207B0A2020202020202020202020207561203D2075';
wwv_flow_api.g_varchar2_table(486) := '61737472696E673B0A2020202020202020202020202F2F62726F77736572203D206E65772042726F7773657228293B0A2020202020202020202020202F2F637075203D206E65772043505528293B0A2020202020202020202020202F2F64657669636520';
wwv_flow_api.g_varchar2_table(487) := '3D206E65772044657669636528293B0A2020202020202020202020202F2F656E67696E65203D206E657720456E67696E6528293B0A2020202020202020202020202F2F6F73203D206E6577204F5328293B0A20202020202020202020202072657475726E';
wwv_flow_api.g_varchar2_table(488) := '20746869733B0A20202020202020207D3B0A202020202020202072657475726E20746869733B0A202020207D3B0A0A2020202055415061727365722E56455253494F4E203D204C494256455253494F4E3B0A2020202055415061727365722E42524F5753';
wwv_flow_api.g_varchar2_table(489) := '4552203D207B0A20202020202020204E414D45202020203A204E414D452C0A20202020202020204D414A4F522020203A204D414A4F522C202F2F20646570726563617465640A202020202020202056455253494F4E203A2056455253494F4E0A20202020';
wwv_flow_api.g_varchar2_table(490) := '7D3B0A2020202055415061727365722E435055203D207B0A2020202020202020415243484954454354555245203A204152434849544543545552450A202020207D3B0A2020202055415061727365722E444556494345203D207B0A20202020202020204D';
wwv_flow_api.g_varchar2_table(491) := '4F44454C2020203A204D4F44454C2C0A202020202020202056454E444F5220203A2056454E444F522C0A202020202020202054595045202020203A20545950452C0A2020202020202020434F4E534F4C45203A20434F4E534F4C452C0A20202020202020';
wwv_flow_api.g_varchar2_table(492) := '204D4F42494C4520203A204D4F42494C452C0A2020202020202020534D4152545456203A20534D41525454562C0A20202020202020205441424C455420203A205441424C45542C0A20202020202020205745415241424C453A205745415241424C452C0A';
wwv_flow_api.g_varchar2_table(493) := '2020202020202020454D4245444445443A20454D4245444445440A202020207D3B0A2020202055415061727365722E454E47494E45203D207B0A20202020202020204E414D45202020203A204E414D452C0A202020202020202056455253494F4E203A20';
wwv_flow_api.g_varchar2_table(494) := '56455253494F4E0A202020207D3B0A2020202055415061727365722E4F53203D207B0A20202020202020204E414D45202020203A204E414D452C0A202020202020202056455253494F4E203A2056455253494F4E0A202020207D3B0A202020202F2F5541';
wwv_flow_api.g_varchar2_table(495) := '5061727365722E5574696C73203D207574696C3B0A0A202020202F2F2F2F2F2F2F2F2F2F2F0A202020202F2F204578706F72740A202020202F2F2F2F2F2F2F2F2F2F0A0A0A202020202F2F20636865636B206A7320656E7669726F6E6D656E740A202020';
wwv_flow_api.g_varchar2_table(496) := '2069662028747970656F66286578706F7274732920213D3D20554E4445465F5459504529207B0A20202020202020202F2F206E6F64656A7320656E760A202020202020202069662028747970656F66206D6F64756C6520213D3D20554E4445465F545950';
wwv_flow_api.g_varchar2_table(497) := '45202626206D6F64756C652E6578706F72747329207B0A2020202020202020202020206578706F727473203D206D6F64756C652E6578706F727473203D2055415061727365723B0A20202020202020207D0A20202020202020202F2F20544F444F3A2074';
wwv_flow_api.g_varchar2_table(498) := '65737421212121212121210A20202020202020202F2A0A2020202020202020696620287265717569726520262620726571756972652E6D61696E203D3D3D206D6F64756C652026262070726F6365737329207B0A2020202020202020202020202F2F2063';
wwv_flow_api.g_varchar2_table(499) := '6C690A202020202020202020202020766172206A736F6E697A65203D2066756E6374696F6E202861727229207B0A2020202020202020202020202020202076617220726573203D205B5D3B0A20202020202020202020202020202020666F722028766172';
wwv_flow_api.g_varchar2_table(500) := '206920696E2061727229207B0A20202020202020202020202020202020202020207265732E70757368286E6577205541506172736572286172725B695D292E676574526573756C742829293B0A202020202020202020202020202020207D0A2020202020';
wwv_flow_api.g_varchar2_table(501) := '202020202020202020202070726F636573732E7374646F75742E7772697465284A534F4E2E737472696E67696679287265732C206E756C6C2C203229202B20275C6E27293B0A2020202020202020202020207D3B0A202020202020202020202020696620';
wwv_flow_api.g_varchar2_table(502) := '2870726F636573732E737464696E2E697354545929207B0A202020202020202020202020202020202F2F2076696120617267730A202020202020202020202020202020206A736F6E697A652870726F636573732E617267762E736C696365283229293B0A';
wwv_flow_api.g_varchar2_table(503) := '2020202020202020202020207D20656C7365207B0A202020202020202020202020202020202F2F2076696120706970650A2020202020202020202020202020202076617220737472203D2027273B0A2020202020202020202020202020202070726F6365';
wwv_flow_api.g_varchar2_table(504) := '73732E737464696E2E6F6E28277265616461626C65272C2066756E6374696F6E2829207B0A20202020202020202020202020202020202020207661722072656164203D2070726F636573732E737464696E2E7265616428293B0A20202020202020202020';
wwv_flow_api.g_varchar2_table(505) := '20202020202020202020696620287265616420213D3D206E756C6C29207B0A202020202020202020202020202020202020202020202020737472202B3D20726561643B0A20202020202020202020202020202020202020207D0A20202020202020202020';
wwv_flow_api.g_varchar2_table(506) := '2020202020207D293B0A2020202020202020202020202020202070726F636573732E737464696E2E6F6E2827656E64272C2066756E6374696F6E202829207B0A20202020202020202020202020202020202020206A736F6E697A65287374722E7265706C';
wwv_flow_api.g_varchar2_table(507) := '616365282F5C6E242F2C202727292E73706C697428275C6E2729293B0A202020202020202020202020202020207D293B0A2020202020202020202020207D0A20202020202020207D0A20202020202020202A2F0A20202020202020206578706F7274732E';
wwv_flow_api.g_varchar2_table(508) := '5541506172736572203D2055415061727365723B0A202020207D20656C7365207B0A20202020202020202F2F20726571756972656A7320656E7620286F7074696F6E616C290A202020202020202069662028747970656F6628646566696E6529203D3D3D';
wwv_flow_api.g_varchar2_table(509) := '2046554E435F5459504520262620646566696E652E616D6429207B0A202020202020202020202020646566696E652866756E6374696F6E202829207B0A2020202020202020202020202020202072657475726E2055415061727365723B0A202020202020';
wwv_flow_api.g_varchar2_table(510) := '2020202020207D293B0A20202020202020207D20656C7365206966202877696E646F7729207B0A2020202020202020202020202F2F2062726F7773657220656E760A20202020202020202020202077696E646F772E5541506172736572203D2055415061';
wwv_flow_api.g_varchar2_table(511) := '727365723B0A20202020202020207D0A202020207D0A0A202020202F2F206A51756572792F5A6570746F20737065636966696320286F7074696F6E616C290A202020202F2F204E6F74653A0A202020202F2F202020496E20414D4420656E762074686520';
wwv_flow_api.g_varchar2_table(512) := '676C6F62616C2073636F70652073686F756C64206265206B65707420636C65616E2C20627574206A517565727920697320616E20657863657074696F6E2E0A202020202F2F2020206A517565727920616C77617973206578706F72747320746F20676C6F';
wwv_flow_api.g_varchar2_table(513) := '62616C2073636F70652C20756E6C657373206A51756572792E6E6F436F6E666C69637428747275652920697320757365642C0A202020202F2F202020616E642077652073686F756C6420636174636820746861742E0A202020207661722024203D207769';
wwv_flow_api.g_varchar2_table(514) := '6E646F77202626202877696E646F772E6A5175657279207C7C2077696E646F772E5A6570746F293B0A2020202069662028747970656F66202420213D3D20554E4445465F545950452026262021242E756129207B0A202020202020202076617220706172';
wwv_flow_api.g_varchar2_table(515) := '736572203D206E657720554150617273657228293B0A2020202020202020242E7561203D207061727365722E676574526573756C7428293B0A2020202020202020242E75612E676574203D2066756E6374696F6E202829207B0A20202020202020202020';
wwv_flow_api.g_varchar2_table(516) := '202072657475726E207061727365722E676574554128293B0A20202020202020207D3B0A2020202020202020242E75612E736574203D2066756E6374696F6E20287561737472696E6729207B0A2020202020202020202020207061727365722E73657455';
wwv_flow_api.g_varchar2_table(517) := '41287561737472696E67293B0A20202020202020202020202076617220726573756C74203D207061727365722E676574526573756C7428293B0A202020202020202020202020666F7220287661722070726F7020696E20726573756C7429207B0A202020';
wwv_flow_api.g_varchar2_table(518) := '20202020202020202020202020242E75615B70726F705D203D20726573756C745B70726F705D3B0A2020202020202020202020207D0A20202020202020207D3B0A202020207D0A0A7D2928747970656F662077696E646F77203D3D3D20276F626A656374';
wwv_flow_api.g_varchar2_table(519) := '27203F2077696E646F77203A2074686973293B0A';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(2764037132619129)
,p_plugin_id=>wwv_flow_api.id(6269942285913443)
,p_file_name=>'js/uap.js'
,p_mime_type=>'application/x-javascript'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
prompt --application/end_environment
begin
wwv_flow_api.import_end(p_auto_install_sup_obj => nvl(wwv_flow_application_install.get_auto_install_sup_obj, false), p_is_component_import => true);
commit;
end;
/
set verify on feedback on define on
prompt  ...done
