package com.ezdml.model;

import java.math.BigDecimal;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.sql.Timestamp;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.JSONValue;


public class TypeUtil {

	public static int ObjToInt(Object o) {
		return ObjectToInt(o);
	}

	public static int ObjectToInt(Object o) {
		return NumberConverter.ObjectToInt(o);
	}

	public static int ObjectToIntDef(Object o, int def) {
		try {
			if (o == null)
				return def;
			else
				return NumberConverter.ObjectToInt(o);
		} catch (Exception e) {
			return def;
		}
	}

	public static long ObjectToLong(Object o) {
		return NumberConverter.ObjectToLong(o);
	}

	public static double ObjectToDouble(Object o) {
		return NumberConverter.ObjectToDouble(o);
	}

	public static double ObjectToDoubleDef(Object o, double def) {
		try {
			if(o==null)
				return def;
			else
				return ObjectToDouble(o);
		} catch (Exception e) {
			return def;
		}
	}

	public static BigDecimal ObjToBigDecimal(Object o){
		return NumberConverter.ObjToBigDecimal(o);
	}

	public static boolean ObjectToBool(Object o) {
		if (o == null)
			return false;
		else if (o instanceof Boolean){
			return ((Boolean)o).booleanValue();
		}
		else if (o instanceof Number){
			if(((Number)o).intValue()==0)
				return false;
			else
				return true;
		} else{
			String s=ObjectToString(o);
			if(s==null || s.length()==0 || "n".equalsIgnoreCase(s) || "null".equalsIgnoreCase(s) || "0".equalsIgnoreCase(s)
					|| "no".equalsIgnoreCase(s) || "false".equalsIgnoreCase(s) || "否".equals(s))
				return false;
			else
				return true;
		}
	}
	
	public static String ObjToStrNotNull(Object o) {
		String s = ObjectToString(o);
		if (s == null)
			s = "";
		return s;
	}

	public static String ObjToStr(Object o) {
		return ObjectToString(o);
	}

	public static String ObjectToString(Object o) {
		if (o == null)
			return null;
		else if (o instanceof String)
			return (String) o;
		else if (o instanceof Date) {
			return DateTimeConverter.DateTimeToStr((Date) o);
		} else
			return o.toString();
	}

	public static Date StrToDate(String s) {
		return DateTimeConverter.StrToDateTime(s);
	}

	public static Date ObjectToDate(Object o) {
		if(o==null)
			return null;
		if(o instanceof Date)
			return (Date)o;
		String s=ObjectToString(o);
		return DateTimeConverter.StrToDateTime(s);
	}

	public static java.sql.Date DateToSqlDate(Date dt) {
		if(dt==null)
			return null;
		if(dt instanceof java.sql.Date)
			return (java.sql.Date)dt;
		return new java.sql.Date(dt.getTime());
	}

	public static java.sql.Date ObjectToSqlDate(Object o) {
		return DateToSqlDate(ObjectToDate(o));
	}

	public static java.util.Date CalendarToDate(Calendar cal) {
		int YY = cal.get(Calendar.YEAR);
		int MM = cal.get(Calendar.MONTH) + 1;
		int DD = cal.get(Calendar.DATE);
		int HH = cal.get(Calendar.HOUR);
		int NN = cal.get(Calendar.MINUTE);
		int SS = cal.get(Calendar.SECOND);
		String s = Integer.toString(YY) + "-" + Integer.toString(MM) + "-"
				+ Integer.toString(DD) + " " + Integer.toString(HH) + ":"
				+ Integer.toString(NN) + ":" + Integer.toString(SS);
		return DateTimeConverter.StrToDateTime(s);
	}

	public static class NumberConverter {
		public static String IntToStr(int i) {
			return Integer.toString(i);
		}

		public static double ObjectToDouble(Object o) {
			if (o == null)
				return 0;
			else if ("".equals(o))
				return 0;
			else if ("null".equals(o))
				return 0;
			else if (o instanceof String)
				return Double.parseDouble((String) o);
			else if (o instanceof Number)
				return ((Number) o).doubleValue();
			else
				return Double.parseDouble(o.toString());
		}

		public static BigDecimal ObjToBigDecimal(Object o){
			if (o == null)
				return BigDecimal.ZERO;
			else if ("".equals(o))
				return BigDecimal.ZERO;
			else if ("null".equals(o))
				return BigDecimal.ZERO;
			else if (o instanceof BigDecimal)
				return (BigDecimal)o;
			else if (o instanceof String)
				return new BigDecimal((String) o);
			else if (o instanceof Long)
				return new BigDecimal(((Long) o).longValue());
			else if (o instanceof Integer)
				return new BigDecimal(((Integer) o).intValue());
			else if (o instanceof Number)
				return new BigDecimal(((Number) o).doubleValue());
			else
				return new BigDecimal(o.toString());
		}

		public static int StrToInt(String s) {
			if (s == null)
				return 0;
			else if ("".equals(s))
				return 0;
			else if ("null".equals(s))
				return 0;
			else
				return Integer.parseInt(s);
		}

		public static int ObjectToInt(Object o) {
			if (o == null)
				return 0;
			else if ("".equals(o))
				return 0;
			else if ("null".equals(o))
				return 0;
			else if (o instanceof String)
				return Integer.parseInt((String) o);
			else if (o instanceof Number)
				return ((Number) o).intValue();
			else
				return Integer.parseInt(o.toString());
		}

		public static long ObjectToLong(Object o) {
			if (o == null)
				return 0;
			else if ("".equals(o))
				return 0;
			else if ("null".equals(o))
				return 0;
			else if (o instanceof String)
				return Long.parseLong((String) o);
			else if (o instanceof Number)
				return ((Number) o).longValue();
			else
				return Long.parseLong(o.toString());
		}

		public static String LongToStr(long i) {
			return Long.toString(i);
		}

		public static long StrToLong(String s) {
			if (s == null)
				return 0;
			return Long.parseLong(s);
		}

		public static String FloatToStr(double d) {
			return Double.toString(d);
		}

		public static double StrToFloat(String s) {
			if (s == null)
				return 0;
			return Double.parseDouble(s);
		}
	}

	public static class DateTypeConverter {
		private static final String DATE_FORMAT = "yyyy-MM-dd";

		private static final String DATE_FORMAT2 = "yyyy年MM月dd日";

		private static final String DATE_FORMAT3 = "yyyyMMdd";

		private static final String DATE_FORMAT4 = "yyyy年MM月";

		private static final String DATE_FORMAT5 = "yyyyMM";

		private static final String DATE_FORMAT6 = "yyyy/MM/dd";

		private static final DateFormat format = new SimpleDateFormat(
				DATE_FORMAT);

		private static final DateFormat format2 = new SimpleDateFormat(
				DATE_FORMAT2);

		private static final DateFormat format3 = new SimpleDateFormat(
				DATE_FORMAT3);

		private static final DateFormat format4 = new SimpleDateFormat(
				DATE_FORMAT4);

		private static final DateFormat format5 = new SimpleDateFormat(
				DATE_FORMAT5);

		private static final DateFormat format6 = new SimpleDateFormat(
				DATE_FORMAT6);

		public static Date StrToDate(String s) {
			if (s == null)
				return null;
			else if ("".equals(s))
				return null;
			else if ("null".equals(s))
				return null;
			try {
				java.util.Date date = format.parse(s);
				return new Date(date.getTime());
			} catch (ParseException e) {
			}

			try {
				java.util.Date date = format2.parse(s);
				return new Date(date.getTime());
			} catch (ParseException e) {
			}

			try {
				java.util.Date date = format3.parse(s);
				return new Date(date.getTime());
			} catch (ParseException e) {
			}

			try {
				java.util.Date date = format4.parse(s);
				return new Date(date.getTime());
			} catch (ParseException e) {
			}

			try {
				java.util.Date date = format5.parse(s);
				return new Date(date.getTime());
			} catch (ParseException e) {
			}

			try {
				java.util.Date date = format6.parse(s);
				return new Date(date.getTime());
			} catch (ParseException e) {
				throw new RuntimeException(s + " invalid date format");
			}
		}

		public static String DateToStr(Date dt) {
			return format.format(dt);
		}
	}

	public static class DateTimeConverter {

		private static final String DATE_FORMAT = "yyyy-MM-dd HH:mm:ss";

		private static final String DATE_FORMAT2 = "yyyy/MM/dd HH:mm:ss";

		private static final String DATE_FORMAT3 = "yyyy年MM月dd日 HH时mm分ss秒";

		private static final String DATE_FORMAT4 = "yyyy年MM月dd日 HH时mm分";

		private static final String DATE_FORMAT5 = "yyyy年MM月dd日 HH:mm";

		private static final String DATE_FORMAT6 = "yyyy-MM-dd HH:mm";

		private static final String DATE_FORMAT7 = "yyyy年MM月dd日";

		private static final String DATE_FORMAT8 = "yyyy-MM-dd";

		private static final String DATE_FORMAT9 = "yyyy/MM/dd";

		private static final String DATE_FORMAT10 = "yyyyMMddHHmmss";

		private static final String DATE_FORMAT11 = "yyyyMMdd HH:mm:ss";

		private static final String DATE_FORMAT12 = "yyyyMMdd HH:mm";

		private static final String DATE_FORMAT13 = "HH:mm:ss";

		private static final String DATE_FORMAT14 = "HH:mm";

		private static final String DATE_FORMAT15 = "yyyy年MM月";

		private static final String DATE_FORMAT16 = "yyyyMMdd";

		private static final String DATE_FORMAT17 = "yyyyMM";

		private static final String DATE_FORMAT18 = "yyyy/MM/dd HH:mm";

		private static final String DATE_FORMAT19 = "yyyy-MM-dd'T'HH:mm";

		private static final String DATE_FORMAT20 = "yyyy/MM/dd'T'HH:mm";
		
		private static final DateFormat format = new SimpleDateFormat(
				DATE_FORMAT);

		private static final DateFormat format2 = new SimpleDateFormat(
				DATE_FORMAT2);

		private static final DateFormat format3 = new SimpleDateFormat(
				DATE_FORMAT3);

		private static final DateFormat format4 = new SimpleDateFormat(
				DATE_FORMAT4);

		private static final DateFormat format5 = new SimpleDateFormat(
				DATE_FORMAT5);

		private static final DateFormat format6 = new SimpleDateFormat(
				DATE_FORMAT6);

		private static final DateFormat format7 = new SimpleDateFormat(
				DATE_FORMAT7);

		private static final DateFormat format8 = new SimpleDateFormat(
				DATE_FORMAT8);

		private static final DateFormat format9 = new SimpleDateFormat(
				DATE_FORMAT9);

		private static final DateFormat format10 = new SimpleDateFormat(
				DATE_FORMAT10);

		private static final DateFormat format11 = new SimpleDateFormat(
				DATE_FORMAT11);

		private static final DateFormat format12 = new SimpleDateFormat(
				DATE_FORMAT12);

		private static final DateFormat format13 = new SimpleDateFormat(
				DATE_FORMAT13);

		private static final DateFormat format14 = new SimpleDateFormat(
				DATE_FORMAT14);

		private static final DateFormat format15 = new SimpleDateFormat(
				DATE_FORMAT15);

		private static final DateFormat format16 = new SimpleDateFormat(
				DATE_FORMAT16);

		private static final DateFormat format17 = new SimpleDateFormat(
				DATE_FORMAT17);

		private static final DateFormat format18 = new SimpleDateFormat(
				DATE_FORMAT18);

		private static final DateFormat format19 = new SimpleDateFormat(
				DATE_FORMAT19);

		private static final DateFormat format20 = new SimpleDateFormat(
				DATE_FORMAT20);
		
		private static final DateFormat[] formatArray = new DateFormat[] {
				format, format2, format3, format4, format5, format6, format18, format19, format20, format7,
				format8, format9, format10, format11, format12, format13,
				format14, format15, format16, format17 };

		public static String DateTimeToStr(Date t) {
			if (t == null)
				return null;
			return format.format(t);
		}

		public static String DateTimeToStr(Date t, String fmt) {
			if (t == null)
				return null;
			for (int i = 0; i < formatArray.length; i++) {
				if (((SimpleDateFormat) formatArray[i]).toPattern()
						.equalsIgnoreCase(fmt))
					return formatArray[i].format(t);
			}
			DateFormat datefmt = new SimpleDateFormat(fmt);
			return datefmt.format(t);
		}

		public static Date StrToDateTime(String s) {
			if (s == null)
				return null;
			s = s.trim();
			if ("".equals(s))
				return null;
			else if ("null".equalsIgnoreCase(s))
				return null;

			for (int i = 0; i < formatArray.length; i++) {
				try {
					java.util.Date date = formatArray[i].parse(s);
					return new Timestamp(date.getTime());
				} catch (ParseException e) {
				}
			}

			throw new RuntimeException(
					s
							+ " invalid date format");
		}

		public static String DateToStr(Date date) {
			if (date == null)
				return null;
			return format8.format(date);
		}

		public static String TimeToStr(Date date) {
			if (date == null)
				return null;
			return format14.format(date);
		}
	}

	public static String formatDate(Date dateTime, String pattern) {
		if (pattern == null || pattern.length() == 0)
			pattern = "yyyy-MM-dd HH:mm:ss";
		SimpleDateFormat f = new SimpleDateFormat(pattern);
		return f.format(dateTime);
	}

	public static Date parseDate(String dateTime, String pattern) {
		Date curdate = null;
		try {
			SimpleDateFormat sdf = new SimpleDateFormat(pattern);
			curdate = sdf.parse(dateTime);
		} catch (Exception ex) {
		}
		return curdate;
	}

	public static String getCurDateTimeStr() {
		return DateTimeConverter.DateTimeToStr(new Date());
	}

	public static String getCurDateStr() {
		return DateTimeConverter.DateToStr(new Date());
	}

	public static String getCurTimeStr() {
		return DateTimeConverter.TimeToStr(new Date());
	}
	
	public static String mapToJsonStr(Map<String, Object> map) {
		JSONObject jo = new JSONObject();
		try {
			mapToJsonStrEx(jo, map);
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
		String jstr = jo.toString();
		return jstr;
	}

	@SuppressWarnings({ "rawtypes", "unchecked" })
	public static void mapToJsonStrEx(JSONObject jo, Map<String, Object> map)
			throws Exception {
		for (String k : map.keySet()) {
			Object o = map.get(k);
			if (o instanceof List) {
				JSONArray ja = new JSONArray();
				listToJsonStrEx(ja, (List) o);
				jo.put(k, ja);
			} else if (o instanceof Map) {
				JSONObject jo2 = new JSONObject();
				mapToJsonStrEx(jo2, (Map) o);
				jo.put(k, jo2);
			} else
				jo.put(k, o);
		}
	}

	@SuppressWarnings({ "rawtypes", "unchecked" })
	private static void listToJsonStrEx(JSONArray ja, List o) throws Exception {
		List ds = (List) o;
		for (int i = 0; i < ds.size(); i++) {
			Object o2 = ds.get(i);
			if (o2 instanceof Map) {
				JSONObject jo2 = new JSONObject();
				mapToJsonStrEx(jo2, (Map) o2);
				ja.add(jo2);
			} else if (o2 instanceof List) {
				JSONArray jo2 = new JSONArray();
				listToJsonStrEx(jo2, (List) o2);
				ja.add(jo2);
			} else
				ja.add(o2);
		}
	}

	public static Map<String, Object> jsonStrToMap(String jStr) {
		JSONObject jObj = StrToJsonObj(jStr);
		return jsonObjToMap(jObj);
	}

	public static Map<String, Object> jsonObjToMap(JSONObject jObj) {
		if (jObj == null)
			return null;
		Map<String, Object> res = new HashMap<String, Object>();

		try {
			parseJsonMap(jObj, res);
			return res;
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
	}

	@SuppressWarnings("rawtypes")
	public static void parseJsonMap(JSONObject jObj, Map<String, Object> map)
			throws Exception {
		Iterator ks = jObj.keySet().iterator();
		while (ks.hasNext()) {
			Object o = ks.next();
			String k = (String) o;
			Object v;
			v = jObj.get(k);
			if (v instanceof JSONObject) {
				Map<String, Object> m = new HashMap<String, Object>();
				parseJsonMap((JSONObject) v, m);
				map.put(k, m);
			} else if (v instanceof JSONArray) {
				JSONArray ja = (JSONArray) v;
				List<Object> ds = new ArrayList<Object>();
				parseJsonArray(ja,ds);
				map.put(k, ds);
			} else {
				map.put(k, v);
			}
		}
	}

	public static void parseJsonArray(JSONArray ja, List<Object> ds) throws Exception  {
		for (int i = 0; i < ja.size(); i++) {
			Object jk = ja.get(i);
			if (jk instanceof JSONObject){
				Map<String, Object> rec = new ArrayMap<String, Object>();
				parseJsonMap((JSONObject) jk, rec);
				ds.add(rec);
			}
			else if (jk instanceof JSONArray){
				List<Object> rec = new ArrayList<Object>();
				parseJsonArray((JSONArray) jk, rec);
				ds.add(rec);
			}
			else if (jk != null){
				ds.add(jk.toString());
			}
		}
	}


	public static JSONObject StrToJsonObj(String sr) {
		Object o = JSONValue.parse(sr);
		if(sr!=null && sr.trim().length()>0 && o==null)
			throw new RuntimeException("StrToJsonObj failed: result should not be null");
		
		return (JSONObject) o;
	}

	@SuppressWarnings("unchecked")
	public static Map<String, Object> CastToMap_SO(Object o) {
		return (Map<String, Object>) o;
	}

	@SuppressWarnings("unchecked")
	public static Map<String, Integer> CastToMap_SI(Object o) {
		return (Map<String, Integer>) o;
	}

	@SuppressWarnings("unchecked")
	public static Map<String, String> CastToMap_SS(Object o) {
		return (Map<String, String>) o;
	}

	@SuppressWarnings("unchecked")
	public static List<Map<String, Object>> CastToList_SO(Object o) {
		return (List<Map<String, Object>>) o;
	}

	@SuppressWarnings("unchecked")
	public static List<Map<String, String>> CastToList_SS(Object o) {
		return (List<Map<String, String>>) o;
	}

	@SuppressWarnings("unchecked")
	public static List<Map<?, ?>> CastToList_M(Object o) {
		return (List<Map<?, ?>>) o;
	}

	@SuppressWarnings("unchecked")
	public static List<String> CastToList_S(Object o) {
		return (List<String>) o;
	}


	public static String genCtGuid(){
		String res =java.util.UUID.randomUUID().toString();
		res=res.replace("-", "").toUpperCase();
		return res;
	}


	public static String urlEncode(String v) {
		return urlEncodeEx(v, "UTF-8");
	}

	public static String urlEncodeEx(String v, String enc) {
		try {
			if (v == null)
				return "";
			v = URLEncoder.encode(v, enc);
		} catch (Exception e) {
		}
		return v;
	}

	public static String urlDecode(String v) {
		return urlDecodeEx(v, "UTF-8");
	}

	public static String urlDecodeEx(String v, String enc) {
		try {
			v = URLDecoder.decode(v, enc);
		} catch (Exception e) {
		}
		return v;
	}

}
