package com.furusystems.dconsole2.core.text.autocomplete {
	import com.furusystems.dconsole2.core.text.TextUtils;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.text.TextField;
	import flash.ui.Keyboard;
	
	/**
	 * ...
	 * @author Andreas Roenning
	 * Heavily based on Ali Mills' work on ternary trees at http://www.asserttrue.com/articles/2006/04/09/actionscript-projects-in-flex-builder-2-0
	 */
	public class AutocompleteManager {
		
		private var txt:String;
		public var dict:AutocompleteDictionary;
		public var scopeDict:AutocompleteDictionary;
		private var paused:Boolean = false;
		private var _targetTextField:TextField;
		public var suggestionActive:Boolean = false;
		public var ready:Boolean = false;
		
		public function AutocompleteManager(targetTextField:TextField) {
			this.targetTextField = targetTextField;
		}
		
		public function setDictionary(newDict:AutocompleteDictionary):void {
			dict = newDict;
			ready = true;
		}
		
		private function changeListener(e:Event):void {
			suggestionActive = false;
			if (!paused) {
				complete();
			}
		}
		
		private function keyDownListener(e:KeyboardEvent):void {
			if (e.keyCode == Keyboard.BACKSPACE || e.keyCode == Keyboard.DELETE) {
				paused = true;
			} else {
				paused = false;
			}
		}
		
		public function complete():void {
			
			//TODO: Start process offset by the nearest occurence of an opening parenthesis
			suggestionActive = false;
			//if the caret is somewhere in an existing word, ignore
			var nextChar:String = _targetTextField.text.charAt(_targetTextField.caretIndex);
			if (_targetTextField.caretIndex < _targetTextField.text.length && nextChar != "" && nextChar != " ") {
				return;
			}
			
			//we only complete single words, so start caret is the beginning of the word the caret is currently in
			var firstIndex:int = TextUtils.getFirstIndexOfWordAtCaretIndex(_targetTextField);
			var str:String = _targetTextField.text.substr(firstIndex, _targetTextField.caretIndex);
			var strParts:Array = str.split("");
			var suggestion:String;
			if (!scopeDict || firstIndex < 1) {
				suggestion = dict.getSuggestion(strParts);
			} else {
				suggestion = scopeDict.getSuggestion(strParts);
			}
			if (suggestion.length > 0) {
				//Sort of a brutal divide and conquer strategy here. Someone smarter take a look?
				var _originalText:String = _targetTextField.text;
				var originalCaretIndex:int = _targetTextField.caretIndex;
				var currentWord:String = TextUtils.getWordAtCaretIndex(_targetTextField);
				var wordSplit:Array = _originalText.split(" ");
				var wordIndex:int = wordSplit.indexOf(currentWord);
				currentWord += suggestion;
				wordSplit.splice(wordIndex, 1, currentWord);
				_targetTextField.text = wordSplit.join(" ");
				
				_targetTextField.setSelection(originalCaretIndex, originalCaretIndex + suggestion.length);
				suggestionActive = true;
			}
		}
		
		public function isKnown(str:String, includeScope:Boolean = false, includeCommands:Boolean = true):Boolean {
			if (scopeDict && includeScope) {
				if (scopeDict.contains(str))
					return true;
			}
			if (includeCommands)
				return dict.contains(str);
			return false;
		}
		
		public function get targetTextField():TextField {
			return _targetTextField;
		}
		
		public function set targetTextField(value:TextField):void {
			try {
				_targetTextField.removeEventListener(Event.CHANGE, changeListener);
				_targetTextField.removeEventListener(KeyboardEvent.KEY_DOWN, keyDownListener);
			} catch (e:Error) {
			} finally {
				_targetTextField = value;
				_targetTextField.addEventListener(Event.CHANGE, changeListener);
				_targetTextField.addEventListener(KeyboardEvent.KEY_DOWN, keyDownListener);
			}
		}
		
		public function correctCase(str:String):String {
			try {
				return dict.correctCase(str);
			} catch (e:Error) {
				if (scopeDict)
					return scopeDict.correctCase(str);
			}
			throw new Error("No correct case found");
		}
	}

}