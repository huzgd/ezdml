package com.ezdml.httpsv;

import java.io.*;
import java.net.InetSocketAddress;
import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import com.ezdml.model.ArrayMap;
import com.ezdml.model.CtMetaField;
import com.ezdml.model.CtMetaTable;
import com.ezdml.model.TypeUtil;
import com.sun.net.httpserver.*;

public class EzHttpServer {
	public static class CtMetaHandler implements HttpHandler {

		private HttpServer server;
		private String accessToken = null;
		private String delayCmd = null;
		private Connection dbconn;
		private String authPassword;
		private int errorPwdCounter = 0;
		private String engineType = "STANDARD";

		public CtMetaHandler(HttpServer server, Connection conn, String httpPwd, String engTp) {
			this.server = server;
			this.dbconn = conn;
			this.authPassword = httpPwd;
			if (this.authPassword != null && this.authPassword.length() == 0)
				this.authPassword = null;
			this.engineType = engTp;
		}

		public void handle(HttpExchange httpExchange) throws IOException {
			String param = httpExchange.getRequestURI().getQuery();
			if (param == null)
				param = "(No param)";
			String pth = httpExchange.getRequestURI().getPath();
			String ua = httpExchange.getRequestHeaders().getFirst("User-Agent");

			String tm = TypeUtil.getCurDateTimeStr();
			String vlog = httpExchange.getRequestMethod() + " " + pth + "?" + param + " " + ua;
			logMsg(vlog);

			Map<String, Object> res = new ArrayMap<String, Object>();
			res.put("resultCode", 0);
			res.put("time", tm);
			try {
				handelEzdmlReq(res, param, httpExchange);
			} catch (RuntimeException re) {
				re.printStackTrace();
				res.put("resultCode", -1);
				res.put("errorMsg", re.getMessage());
			} catch (Exception e) {
				e.printStackTrace();
				res.put("resultCode", -1);
				res.put("errorMsg", e.getMessage());
			}

			String cont = TypeUtil.mapToJsonStr(res);
			byte[] bs = cont.getBytes("UTF-8");

			httpExchange.getResponseHeaders().add("Content-Type", "text/plain; charset=UTF-8");
			httpExchange.sendResponseHeaders(200, bs.length);

			OutputStream os = httpExchange.getResponseBody();
			os.write(bs);
			os.close();

			int len = cont.length();
			vlog = len < 1024 ? cont : cont.substring(0, 1020) + "...";
			logMsg("RES (" + bs.length + " bytes)" + vlog);

			if ("stopServer".equals(delayCmd)) {
				if (server != null) {
					HttpServer svr = server;
					server = null;
					logMsg("EzdmlJdbcHttpServer stopping...");
					svr.stop(2);
					try {
						logMsg("Closing database connection...");
						dbconn.close();
					} catch (SQLException e) {
						e.printStackTrace();
					}
					dbconn = null;
					logMsg("EzdmlJdbcHttpServer stopped.");
				}
			}
		}

		private void handelEzdmlReq(Map<String, Object> res, String param, HttpExchange httpExchange) throws Exception {

			if (this.dbconn == null)
				throw new RuntimeException("database not ready");

			String[] paramsp = param.split("&");
			Map<String, String> pmap = new HashMap<String, String>();
			for (String par : paramsp) {
				int po = par.indexOf("=");
				if (po > 0) {
					pmap.put(par.substring(0, po), par.substring(po + 1));
				}
			}
			
			if("POST".equalsIgnoreCase(httpExchange.getRequestMethod())) {
				String sBody=null;
				InputStream inputStream = null;
				try {
					inputStream = httpExchange.getRequestBody();
					ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
					byte[] bytes = new byte[1024];
					int a;
					while ((a = inputStream.read(bytes)) != -1) {
						byteArrayOutputStream.write(bytes, 0, a);
					}
					sBody = byteArrayOutputStream.toString("UTF-8");
				} catch (Exception e) {
					e.printStackTrace();
				} finally {
					if (inputStream != null) {
						try {
							inputStream.close();
						} catch (Exception e) {
							e.printStackTrace();
						}
					}
				}

				paramsp = sBody.split("&");
				String pLog="post params:";
				for (String par : paramsp) {
					int po = par.indexOf("=");
					if (po > 0) {
						String pname=par.substring(0, po);
						String pvalue=TypeUtil.urlDecode( par.substring(po + 1));
						pmap.put(pname,pvalue);
						pLog=pLog+"\n  "+pname+"=";
						if(pvalue.length()>512)
							pLog=pLog+pvalue.substring(0,500)+"...";
						else
							pLog=pLog+pvalue;
					}
				}
				logMsg(pLog);
				//logMsg(pmap.toString());
			}

			String cmd = pmap.get("cmd");
			if (cmd == null || cmd.length() == 0)
				throw new RuntimeException("cmd not assigned");
			String eztoken = pmap.get("eztoken");
			if (eztoken == null)
				eztoken = "";
			String param1 = pmap.get("param1");
			String param2 = pmap.get("param2");
			String data = pmap.get("data");

			if ("connect".equals(cmd)) {
				if (this.authPassword != null) {
					if (accessToken != null)
						throw new RuntimeException("already connected by aother client");
					if (errorPwdCounter > 5)
						throw new RuntimeException("too many errors");
					if(param2==null || param2.length()==0)
						throw new RuntimeException("password needed");
					if (!authPassword.equals(param2)) {
						errorPwdCounter++;
						throw new RuntimeException("invalid password");
					}
				}

				errorPwdCounter = 0;
				accessToken = TypeUtil.genCtGuid().toLowerCase();

				res.put("EzdmlToken", accessToken);
				res.put("EngineType", engineType);

				try {
					DatabaseMetaData meta = dbconn.getMetaData();
					String DbSchema = meta.getUserName();
					res.put("DbSchema", DbSchema);
				}catch (Throwable cme){
					logMsg("Error getting current user name: "+cme.getMessage());
					cme.printStackTrace();
				}

				//res.put("NeedGenCustomSql", "true"); // will call GenCustomSql when needed

				logMsg("client connected: " + httpExchange.getRemoteAddress() + " token:" + accessToken);

				return;
			}

			if (cmd.equals("stop")) {
				if (this.authPassword != null) {
					if (errorPwdCounter > 5)
						throw new RuntimeException("too many errors");
					if (!authPassword.equals(param2)) {
						errorPwdCounter++;
						throw new RuntimeException("invalid password");
					}
				}

				delayCmd = "stopServer";
				res.put("RESULT", "OK");
				res.put("msg", "server stopping");
				return;
			}

			checkLogon(eztoken);

			if ("disconnect".equals(cmd)) {
				accessToken = null;
				return;
			}

			if ("ExecSql".equals(cmd)) {
				PreparedStatement stm = this.dbconn.prepareStatement(param1);
				if (!stm.execute())
					res.put("RESULT", "OK");
				else
					res.put("RESULT", "SQL returns a result-set");
				return;
			}

			if ("OpenTable".equals(cmd)) {
				PreparedStatement stm = this.dbconn.prepareStatement(param1);
				ResultSet rs = stm.executeQuery();

				ResultSetMetaData md = rs.getMetaData();
				int columnCount = md.getColumnCount();
				List<Map<String, Object>> cols = new ArrayList<Map<String, Object>>();
				for (int i = 1; i <= columnCount; i++) {
					Map<String, Object> col = new ArrayMap<String, Object>();
					col.put("Name", md.getColumnName(i));
					col.put("DataType", getColDataTypeName(md.getColumnType(i)));
					cols.add(col);
				}
				res.put("Cols", cols);

				List<Map<String, Object>> ds = convertResultSetToList(rs);
				res.put("Rows", ds);
				return;
			}

			if ("GetDbUsers".equals(cmd)) {
				DatabaseMetaData meta = dbconn.getMetaData();
				ResultSet rs = meta.getSchemas();
				List<String> ds = new ArrayList<String>();
				while (rs.next()) {
					String tableSchem = sqlRsGetString(rs, "TABLE_SCHEM");
					ds.add(tableSchem);
				}
				rs.close();
				res.put("itemList", ds);
				return;
			}

			if ("GetDbObjs".equals(cmd)) {
				if (param1 != null && param1.length() == 0)
					param1 = null;
				DatabaseMetaData meta = dbconn.getMetaData();
				String[] types = { "TABLE" };
				ResultSet rs = meta.getTables(null, param1, null, types);
				List<String> ds = new ArrayList<String>();
				while (rs.next()) {
					String tableSchem = sqlRsGetString(rs, "TABLE_SCHEM");
					String tableName = sqlRsGetString(rs, "TABLE_NAME");
					if (tableSchem != null && tableSchem.length() > 0
							&& (param1 == null || !param1.equalsIgnoreCase(tableSchem)))
						ds.add(tableSchem + "." + tableName);
					else
						ds.add(tableName);
				}
				rs.close();
				res.put("itemList", ds);
				return;
			}

			if ("GetObjInfos".equals(cmd)) {
				if (param1 != null && param1.length() == 0)
					param1 = null;
				if (param2 == null || param2.length() == 0)
					throw new RuntimeException("table name not assigned");
				DatabaseMetaData meta = dbconn.getMetaData();

				boolean dbTypeName = false;
				if (data != null && data.contains("[DBTYPENAMES]"))
					dbTypeName = true;

				String[] types = { "TABLE" };
				ResultSet rs = meta.getTables(null, param1, param2, types);
				if (!rs.next())
					throw new RuntimeException("table not found - " + (param1 == null ? "" : param1 + ".") + param2);
				String tableName = sqlRsGetString(rs, "TABLE_NAME");
				String tableRemark = sqlRsGetString(rs, "REMARKS");
				if (rs.next())
					throw new RuntimeException(
							"too many tables found - " + (param1 == null ? "" : param1 + ".") + param2);
				rs.close();

				CtMetaTable tb = new CtMetaTable();
				tb.setName(tableName);
				tb.setMemo(tableRemark);

				rs = meta.getColumns(null, param1, param2, null);

				while (rs.next()) {
					//注意：元数据字段的读取是有顺序的，不能随意调整
					CtMetaField fd = tb.newField();
					fd.setName(sqlRsGetString(rs, "COLUMN_NAME"));

					int colTp = sqlRsGetInt(rs, "DATA_TYPE");
					String tpName=sqlRsGetString(rs, "TYPE_NAME");
					int colSz=sqlRsGetInt(rs, "COLUMN_SIZE");
					int colDig=sqlRsGetInt(rs, "DECIMAL_DIGITS");
					
					if (colTp == java.sql.Types.NUMERIC || colTp == java.sql.Types.DECIMAL)
						if (colDig == 0)
							colTp = java.sql.Types.INTEGER;
					int cTp = getCtDataType(colTp);
					fd.setDataType(cTp);
					if (dbTypeName || cTp >=8 )
						fd.setDataTypeName(tpName);
					if (cTp != 2 && cTp != 4 && cTp != 7) {
						fd.setDataLength(colSz);
						fd.setDataScale(colDig);
					}
					int iNullable=sqlRsGetInt(rs, "NULLABLE");
					fd.setMemo(sqlRsGetString(rs, "REMARKS"));
					fd.setDefaultValue(sqlRsGetString(rs, "COLUMN_DEF"));
					fd.setOrderNo(sqlRsGetInt(rs, "ORDINAL_POSITION"));
					String sIsNullable=sqlRsGetString(rs, "IS_NULLABLE");

					if (iNullable == DatabaseMetaData.columnNoNulls
							|| "NO".equals(sIsNullable))
						fd.setNullable(false);
					else
						fd.setNullable(true);

					if(!"HIVE".equalsIgnoreCase(engineType)){
						if ("YES".equals(sqlRsGetString(rs, "IS_AUTOINCREMENT"))) {
							if (fd.getDefaultValue() == null || fd.getDefaultValue().length() == 0) {
								fd.setDefaultValue("{auto_increment}");
							}
						}
					}
					

				}
				rs.close();

				rs = meta.getPrimaryKeys(null, param1, param2);
				while (rs.next()) {
					String col = sqlRsGetString(rs, "COLUMN_NAME");
					if (col != null && col.length() > 0) {
						CtMetaField fd = tb.fieldByName(col);
						if (fd != null)
							fd.setKeyFieldType(1);
					}
				}
				rs.close();

				rs = meta.getIndexInfo(null, param1, param2, false, false);
				while (rs.next()) {
					boolean nonUnique = sqlRsGetBoolean(rs, "NON_UNIQUE");
					String col = sqlRsGetString(rs, "COLUMN_NAME");
					if (col != null && col.length() > 0) {
						CtMetaField fd = tb.fieldByName(col);
						if (fd != null) {
							if (nonUnique)
								fd.setIndexType(2);
							else {
								if (fd.getKeyFieldType() != 1)
									fd.setIndexType(1);
							}
						}
					}
				}
				rs.close();

				rs = meta.getImportedKeys(null, param1, param2);
//				List<Map<String, Object>> ds = convertResultSetToList(rs);
//				logMsg(ds);
				while (rs.next()) {
					String rtb = sqlRsGetString(rs, "PKTABLE_NAME");
					String rcol = sqlRsGetString(rs, "PKCOLUMN_NAME");
					String col = sqlRsGetString(rs, "FKCOLUMN_NAME");
					if (col != null && col.length() > 0) {
						CtMetaField fd = tb.fieldByName(col);
						if (fd != null) {
							if (fd.getKeyFieldType() != 1) {
								fd.setKeyFieldType(3);
								fd.setRelateTable(rtb);
								fd.setRelateField(rcol);
							}
						}
					}
				}
				rs.close();

				tb.saveToMap(res);
				return;
			}

			if ("ObjectExists".equals(cmd)) {
				if (param1 != null && param1.length() == 0)
					param1 = null;
				if (param2 == null || param2.length() == 0)
					throw new RuntimeException("object name not assigned");
				DatabaseMetaData meta = dbconn.getMetaData();

				ResultSet rs = meta.getTables(null, param1, param2, null);
				boolean bFound = false;
				while (rs.next()) {
					bFound = true;
					break;
				}
				rs.close();

				res.put("RESULT", bFound ? "true" : "false");
				return;
			}

			if ("GenCustomSql".equals(cmd)) {
				/**
				 * you can generate your own sql here
				 * param1: json string of designing table
				 * param2: json string of target table (in real database), may be null
				 * data:   json string of options map, may contains possible parameters:
				 *   GenCreateTableSql: true/false, "true" means need to generate DDL SQLs like "create table ..." or "alter table ..."
				 *   GenCreateConstrainsSql: true/false, "true" means to generate DDL SQLs of foreign-keys
				 *   EngineType: ORACLE/MYSQL/SQLSERVER/SQLITE/POSTGRESQL ... may be empty
				 *   DefaultResult: default SQL result generated by EZDML
				 *   Options: other options. may contains "[GEN_SELECT_SQL]" which means to generate SELECT SQL of demo data
				 */

				if (param1 == null || param1.length() == 0)
					throw new RuntimeException("table1 not assigned");
				if (param2 != null && param2.length() == 0)
					param2 = null;
				if (data == null || data.length() == 0)
					throw new RuntimeException("option data not assigned");

				Map<String, Object> optmap = TypeUtil.jsonStrToMap(data);
				if (optmap == null)
					throw new RuntimeException("option data map invalid");
				String defRes = TypeUtil.ObjToStr(optmap.get("DefaultResult"));

				res.put("RESULT", "/* gen by http server " + TypeUtil.getCurDateTimeStr() + " */\r\n" + defRes);
				return;
			}

			throw new RuntimeException("unsupported cmd - " + cmd);
		}

		private static String CtDataTypeNames[] = { "Unknow", "String", "Integer", "Float", "Date", "Bool", "Enum",
				"Blob", "Object", "Calculate", "List", "Function", "Event", "Other" };

		private int getCtDataType(int columnType) {
			String stp = getColDataTypeName(columnType);
			for (int i = 0; i < CtDataTypeNames.length; i++)
				if (CtDataTypeNames[i].contentEquals(stp))
					return i;
			return 0;
		}

		private String getColDataTypeName(int columnType) {
			switch (columnType) {
			case java.sql.Types.TINYINT:
			case java.sql.Types.SMALLINT:
			case java.sql.Types.INTEGER:
			case java.sql.Types.BIGINT:
				return "Integer";
			case java.sql.Types.FLOAT:
			case java.sql.Types.REAL:
			case java.sql.Types.DOUBLE:
			case java.sql.Types.NUMERIC:
			case java.sql.Types.DECIMAL:
				return "Float";
			case java.sql.Types.DATE:
			case java.sql.Types.TIME:
			case java.sql.Types.TIMESTAMP:
			case java.sql.Types.TIME_WITH_TIMEZONE:
			case java.sql.Types.TIMESTAMP_WITH_TIMEZONE:
				return "Date";
			case java.sql.Types.BINARY:
			case java.sql.Types.VARBINARY:
			case java.sql.Types.LONGVARBINARY:
			case java.sql.Types.BLOB:
				return "Blob";
			case java.sql.Types.BOOLEAN:
				return "Bool";
			case java.sql.Types.JAVA_OBJECT:
			case java.sql.Types.DISTINCT:
			case java.sql.Types.STRUCT:
			case java.sql.Types.SQLXML:
				return "Object";
			case java.sql.Types.ARRAY:
				return "List";
			case java.sql.Types.OTHER:
			case java.sql.Types.REF:
			case java.sql.Types.DATALINK:
			case java.sql.Types.REF_CURSOR:
				return "Other";
//			case java.sql.Types.BIT:
//			case java.sql.Types.CHAR:
//			case java.sql.Types.VARCHAR:
//			case java.sql.Types.LONGVARCHAR:
//			case java.sql.Types.NULL:
//			case java.sql.Types.CLOB:
//			case java.sql.Types.ROWID:
//			case java.sql.Types.NCHAR:
//			case java.sql.Types.NVARCHAR:
//			case java.sql.Types.LONGNVARCHAR:
//			case java.sql.Types.NCLOB:
			}
			return "String";
		}

		private void checkLogon(String eztoken) {
			if (this.authPassword == null)
				return;
			if (eztoken.length() == 0)
				throw new RuntimeException("logon-needed");
			if (accessToken == null)
				throw new RuntimeException("not-logged-on");
			if (!eztoken.equals(accessToken)) {
				try {
					Thread.sleep(1000);
				} catch (InterruptedException e) {
					e.printStackTrace();
				}
				throw new RuntimeException("logon-invalid");
			}
		}

		public static List<Map<String, Object>> convertResultSetToList(ResultSet rs) throws SQLException {
			List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
			ResultSetMetaData md = rs.getMetaData();

			while (rs.next()) {
				Map<String, Object> rowData = getRowDataMap(rs, md);
				list.add(rowData);
			}
			return list;
		}

		protected static Map<String, Object> getRowDataMap(ResultSet rs, ResultSetMetaData md) throws SQLException {
			int columnCount = md.getColumnCount();
			Map<String, Object> rowData = new ArrayMap<String, Object>();
			for (int i = 1; i <= columnCount; i++) {
				if (md.getColumnType(i) == java.sql.Types.BLOB || md.getColumnType(i) == java.sql.Types.BINARY
						|| md.getColumnType(i) == java.sql.Types.VARBINARY
						|| md.getColumnType(i) == java.sql.Types.LONGVARBINARY)
					rowData.put(md.getColumnName(i), getHexStr(rs.getBytes(i)));
				else if (md.getColumnType(i) == java.sql.Types.CLOB)
					rowData.put(md.getColumnName(i), sqlRsGetString(rs, i));
				else if (md.getColumnType(i) == java.sql.Types.DATE || md.getColumnType(i) == java.sql.Types.TIME
						|| md.getColumnType(i) == java.sql.Types.TIMESTAMP)
					rowData.put(md.getColumnName(i),
							rs.getTimestamp(i) == null ? null : TypeUtil.formatDate(rs.getTimestamp(i), null));
				else
					rowData.put(md.getColumnName(i), rs.getObject(i));
			}
			return rowData;
		}

		private static String getHexStr(byte[] byteArray) {
			if (byteArray == null)
				return null;
			StringBuffer hexString = new StringBuffer();
			String hex = null;
			for (int i = 0; i < byteArray.length; i++) {
				hex = Integer.toHexString(0xFF & byteArray[i]);
				if (hex.length() == 1)
					hexString.append("0" + hex);
				else
					hexString.append(hex);
			}
			return hexString.toString().toUpperCase();
		}

	}

	public static String sqlRsGetString(ResultSet rs, String col) {
		try {
			return rs.getString(col);
		} catch (SQLException e) {
			logMsg("Error getting col string value: " + col);
			e.printStackTrace();
			return null;
		}
	}

	public static String sqlRsGetString(ResultSet rs, int icol) {
		try {
			return rs.getString(icol);
		} catch (SQLException e) {
			logMsg("Error getting col string value: " + icol);
			e.printStackTrace();
			return null;
		}
	}

	public static int sqlRsGetInt(ResultSet rs, String col) {
		try {
			return rs.getInt(col);
		} catch (SQLException e) {
			logMsg("Error getting col int value: " + col);
			e.printStackTrace();
			return 0;
		}
	}

	public static boolean sqlRsGetBoolean(ResultSet rs, String col) {
		try {
			return rs.getBoolean(col);
		} catch (SQLException e) {
			logMsg("Error getting col bool value: " + col);
			e.printStackTrace();
			return false;
		}
	}

	private static String valIfNull(String oldVal, String newVal){
		if(oldVal!=null && oldVal.length()>0)
			return oldVal;
		else
			return newVal;
	}

	private static String getDefConfigFile() {
		try{
			String path = EzHttpServer.class.getProtectionDomain().getCodeSource().getLocation().getPath();
			if (path.startsWith("file://"))
				path = path.substring("file:/".length());
			else if (path.startsWith("file:"))
				path = path.substring("file:".length()); // solaris下测试发现就只有一个斜杠
			try {
				path = java.net.URLDecoder.decode(path, "UTF-8");
			} catch (UnsupportedEncodingException e) {
				e.printStackTrace();
			}

			int iPos = path.lastIndexOf("/lib/");
			if (iPos == -1) {
				logMsg("Searching lib path failed: "+path);
				return null;
			}
			path = path.substring(0, iPos);
			path = path +File.separator+"jdbc.properties";
			File f=new File(path);
			if(f.exists()) {
				logMsg("Config file found: "+path);
				return path;
			} else{
				logMsg("Config file not found: "+path);
			}
		}catch (Throwable ex){
			ex.printStackTrace();
		}
		return null;
	}

	private static void logMsg(String msg) {
		System.out.println(TypeUtil.getCurDateTimeStr() + " " + msg);
	}

	public static void main(String[] args) {
		//jdbc.config=D:/EZDML_win64/jdbc/jdbc.properties
		//jdbc.driver=oracle.jdbc.OracleDriver jdbc.url=jdbc:oracle:thin:@192.168.1.2:1522:orcl jdbc.username=TEST jdbc.password=1234 jdbc.engineType=ORACLE http.password= http.port=8083
		//jdbc.driver=com.mysql.cj.jdbc.Driver jdbc.url=jdbc:mysql://localhost:3306/test?serverTimezone=UTC jdbc.username=root jdbc.password=1234 jdbc.engineType=MYSQL http.password= http.port=8083
		//jdbc.driver=org.apache.hive.jdbc.HiveDriver jdbc.url=jdbc:hive2://192.168.1.127:10000/default jdbc.username=hive jdbc.password=hive jdbc.engineType=HIVE http.password= http.port=8083
		Connection conn=null;
		try {
			logMsg("EzdmlJdbcHttpServer V20220730 by huzzz@163.com, launching...");
			String jdbcDriver = null, jdbcUrl = null, jdbcUser = null, jdbcPwd = null, httpPwd = null, engTp = null, config = null;
			int httpPort = 0;
			for (int i = 0; i < args.length; i++) {
				String s = args[i];
				if (s == null)
					continue;
				if (s.startsWith("jdbc.config="))
					config = s.substring("jdbc.config=".length());
				else if (s.startsWith("jdbc.driver="))
					jdbcDriver = s.substring("jdbc.driver=".length());
				else if (s.startsWith("jdbc.url="))
					jdbcUrl = s.substring("jdbc.url=".length());
				else if (s.startsWith("jdbc.username="))
					jdbcUser = s.substring("jdbc.username=".length());
				else if (s.startsWith("jdbc.password="))
					jdbcPwd = s.substring("jdbc.password=".length());
				else if (s.startsWith("jdbc.engineType=")) {
					engTp = s.substring("jdbc.engineType=".length());
					if(engTp!=null && engTp.trim().length()==0)
						engTp=null;
				}
				else if (s.startsWith("http.password=")) {
					httpPwd = s.substring("http.password=".length());
					if (httpPwd != null && httpPwd.trim().length() == 0)
						httpPwd = null;
				} else if (s.startsWith("http.port=")) {
					s = s.substring("http.port=".length());
					httpPort = TypeUtil.ObjectToIntDef(s, httpPort);
				}
			}

			if(config == null)
				config=getDefConfigFile();
			if(config != null && config.length()>0){
				logMsg("Loading config file... " + config);
				InputStream inputStream = new BufferedInputStream(new FileInputStream(config));
				Properties properties = new Properties();
				properties.load(inputStream);
				jdbcDriver=valIfNull(jdbcDriver,properties.getProperty("jdbc.driver"));
				jdbcUrl=valIfNull(jdbcUrl,properties.getProperty("jdbc.url"));
				jdbcUser=valIfNull(jdbcUser,properties.getProperty("jdbc.username"));
				jdbcPwd=valIfNull(jdbcPwd,properties.getProperty("jdbc.password"));
				engTp=valIfNull(engTp,properties.getProperty("jdbc.engineType"));
				httpPwd=valIfNull(httpPwd,properties.getProperty("http.password"));
				if(httpPort==0)
					httpPort=TypeUtil.ObjectToIntDef(properties.getProperty("http.port"), 0);
			}

			if (engTp == null && jdbcUrl != null) {
				String s = jdbcUrl.toLowerCase();
				if (s.contains("oracle"))
					engTp = "ORACLE";
				else if (s.contains("mysql"))
					engTp = "MYSQL";
				else if (s.contains("sqlserver"))
					engTp = "SQLSERVER";
				else if (s.contains("sqlite"))
					engTp = "SQLITE";
				else if (s.contains("postgresql"))
					engTp = "POSTGRESQL";
				else if (s.contains("hive"))
					engTp = "HIVE";
			}
			if (httpPort <= 0 || jdbcDriver == null || jdbcUrl == null || jdbcUser == null || jdbcPwd == null
					|| engTp == null) {
				logMsg("Error! config or parameters needed: jdbc.config=D:/EZDML_win64/jdbc/jdbc.properties jdbc.driver=oracle.jdbc.OracleDriver jdbc.url=jdbc:oracle:thin:@192.168.1.15:1521:ORCL jdbc.username=scott jdbc.password=1234 http.port=8083 http.password=abcd jdbc.engineType=ORACLE");
				return;
			}

			logMsg("Loading driver class... " + jdbcDriver);
			Class.forName(jdbcDriver);

			logMsg("Connecting database... " + jdbcUser + "/" + jdbcUrl);
			Properties props = new Properties();
			props.put("remarksReporting", "true");
			props.put("user", jdbcUser);
			props.put("password", jdbcPwd);
			conn = DriverManager.getConnection(jdbcUrl, props);

			logMsg("Connect database success.");

			logMsg("EzdmlJdbcHttpServer starting... binding port: " + httpPort + " engineType: " + engTp);
			HttpServer server = HttpServer.create(new InetSocketAddress(httpPort), 0);
			server.createContext("/ezdml/", new CtMetaHandler(server, conn, httpPwd, engTp));
			server.setExecutor(null);
			server.start();
			logMsg("EzdmlJdbcHttpServer started at http://localhost:" + httpPort + "/ezdml/"
					+ (httpPwd == null ? " (NO PASSWORD AUTH!!!)" : " (PASSWORD AUTH ENABLED)"));
		} catch (Exception e) {
			logMsg("Failed with error: "+e.getMessage());
			//e.printStackTrace();
			if(conn!=null)
				try {
					logMsg("Closing database connection...");
					conn.close();
				} catch (SQLException e1) {
					//e1.printStackTrace();
				}
			logMsg("Exiting...");
			try {
				Thread.sleep(5000);
			} catch (InterruptedException e1) {
				//e1.printStackTrace();
			}
		}
	}

}
