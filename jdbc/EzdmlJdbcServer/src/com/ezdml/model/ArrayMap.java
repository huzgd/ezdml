package com.ezdml.model;


import java.io.IOException;
import java.io.Serializable;
import java.util.AbstractMap;
import java.util.AbstractSet;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.Map;
import java.util.Set;

public class ArrayMap<K,V> extends AbstractMap<K,V> implements Cloneable, Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 4638018125560214478L;


	static class Entry implements Map.Entry<Object, Object>, Serializable {
		/**
		 * 
		 */
		private static final long serialVersionUID = -5102537653979829284L;
		
		protected Object key, value;

		public Entry(Object key, Object value) {
			this.key = key;
			this.value = value;
		}

		public Object getKey() {
			return key;
		}

		public Object getValue() {
			return value;
		}

		public Object setValue(Object newValue) {
			Object oldValue = value;
			value = newValue;
			return oldValue;
		}

		public boolean equals(Object o) {
			if (!(o instanceof Map.Entry<?,?>)) {
				return false;
			}
			Map.Entry<?,?> e = (Map.Entry<?,?>) o;
			return (key == null ? e.getKey() == null : key.equals(e.getKey()))
					&& (value == null ? e.getValue() == null : value.equals(e
							.getValue()));
		}

		public int hashCode() {
			int keyHash = (key == null ? 0 : key.hashCode());
			int valueHash = (value == null ? 0 : value.hashCode());
			return keyHash ^ valueHash;
		}

		public String toString() {
			return key + "=" + value;
		}
	}

	private Set<Entry> entries = null;

	private ArrayList<Entry> list;

	public ArrayMap() {
		list = new ArrayList<Entry>();
	}

	@SuppressWarnings({ "unchecked", "rawtypes" })
	public ArrayMap(Map map) {
		list = new ArrayList<Entry>();
		putAll(map);
	}

	public ArrayMap(int initialCapacity) {
		list = new ArrayList<Entry>(initialCapacity);
	}

	@SuppressWarnings({ "unchecked", "rawtypes" })
	public Set entrySet() {
		if (entries == null) {
			entries = new AbstractSet<Entry>() {
				public void clear() {
					list.clear();
				}

				public Iterator<Entry> iterator() {
					return list.iterator();
				}

				public int size() {
					return list.size();
				}
			};
		}
		return entries;
	}

	@SuppressWarnings("unchecked")
	public V put(K key, V value) {
		int size = list.size();
		Entry entry = null;
		int i;
		if (key == null) {
			for (i = 0; i < size; i++) {
				entry = (Entry) (list.get(i));
				if (entry.getKey() == null) {
					break;
				}
			}
		} else {
			for (i = 0; i < size; i++) {
				entry = (Entry) (list.get(i));
				if (key.equals(entry.getKey())) {
					break;
				}
			}
		}
		V oldValue = null;
		if (i < size) {
			oldValue = (V) entry.getValue();
			entry.setValue(value);
		} else {
			list.add(new Entry(key, value));
		}
		return oldValue;
	}

	public Object clone() {
		return new ArrayMap<K, V>(this);
	}
	

    private void writeObject(java.io.ObjectOutputStream s)
        throws IOException
    {
		// Write out the threshold, loadfactor, and any hidden stuff
    	Set<Entry> a=this.entries;
    	try{
    		this.entries=null;
    		s.defaultWriteObject();
    	}
    	finally{
    		this.entries=a;
    	}

    }


    private void readObject(java.io.ObjectInputStream s) throws IOException,
			ClassNotFoundException {

   		this.entries=null;

		// Read in the threshold, loadfactor, and any hidden stuff
		s.defaultReadObject();
	}

}
