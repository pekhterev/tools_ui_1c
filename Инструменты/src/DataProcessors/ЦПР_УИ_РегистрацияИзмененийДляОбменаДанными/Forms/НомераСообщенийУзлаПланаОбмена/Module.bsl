////////////////////////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ
//

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ВыполнитьПроверкуПравДоступа("Администрирование", Метаданные);
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	УзелОбменаСсылка = Параметры.УзелОбменаСсылка;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ПрочитатьНомераСообщений();
	Заголовок = УзелОбменаСсылка;
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ
//

// Производит запись измененных данных и закрывает форму.
&НаКлиенте
Процедура ЗаписатьИзмененияУзла(Команда)
	ЗаписатьНомераСообщений();
	Оповестить("ИзменениеДанныхУзлаОбмена", УзелОбменаСсылка, ЭтотОбъект);
	Закрыть();
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ
//

&НаСервере
Функция ЭтотОбъект(ТекущийОбъект=Неопределено) 
	Если ТекущийОбъект=Неопределено Тогда
		Возврат РеквизитФормыВЗначение("Объект");
	КонецЕсли;
	ЗначениеВРеквизитФормы(ТекущийОбъект, "Объект");
	Возврат Неопределено;
КонецФункции

&НаСервере
Процедура ПрочитатьНомераСообщений()
	Данные = ЭтотОбъект().ПолучитьПараметрыУзлаОбмена(УзелОбменаСсылка, "НомерОтправленного, НомерПринятого, ВерсияДанных");
	Если Данные=Неопределено Тогда
		НомерОтправленного = Неопределено;
		НомерПринятого     = Неопределено;
		ВерсияДанных       = Неопределено;
	Иначе
		НомерОтправленного = Данные.НомерОтправленного;
		НомерПринятого     = Данные.НомерПринятого;
		ВерсияДанных       = Данные.ВерсияДанных;
	КонецЕсли;
КонецПроцедуры	

&НаСервере
Процедура ЗаписатьНомераСообщений()
	Данные = Новый Структура("НомерОтправленного, НомерПринятого", НомерОтправленного, НомерПринятого);
	ЭтотОбъект().УстановитьПараметрыУзлаОбмена(УзелОбменаСсылка, Данные);
КонецПроцедуры
