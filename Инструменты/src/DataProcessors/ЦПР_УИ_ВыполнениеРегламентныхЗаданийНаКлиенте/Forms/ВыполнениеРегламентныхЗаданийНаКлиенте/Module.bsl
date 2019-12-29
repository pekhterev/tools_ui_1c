#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ОбновитьТаблицуРегламентныхЗаданий();
	ИнтервалВремениПроверкиВыполнения = 5; // 5 секунд.
	
	ПараметрыОтбора = Новый Структура;
	ПараметрыОтбора.Вставить("Выполнять", Истина);
	Включено = ТаблицаРегламентныхЗаданий.НайтиСтроки(ПараметрыОтбора).Количество();
	
	Если Включено <> 0 Тогда
		Элементы.СтрокаСостояния.Заголовок = ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Отмеченные регламентные задания выполняются на этом клиентском компьютере (%1)...'"),
			Включено);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
#Если Не ТолстыйКлиентОбычноеПриложение Тогда
	
#КонецЕсли
	
	ОсталосьДоНачалаВыполнения = ИнтервалВремениПроверкиВыполнения + 1;
	ВыполнитьРегламентныеЗадания();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура РегламентныеЗаданияВыполнятьПриИзменении(Элемент)
	ТекущиеДанные = Элементы.РегламентныеЗадания.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ИзменитьИспользованиеРегламентногоЗадания(ТекущиеДанные.Идентификатор, ТекущиеДанные.Выполнять);
	
	ПараметрыОтбора = Новый Структура;
	ПараметрыОтбора.Вставить("Выполнять", Истина);
	Включено = ТаблицаРегламентныхЗаданий.НайтиСтроки(ПараметрыОтбора).Количество();
	
	Если Включено = 0 Тогда
		Элементы.СтрокаСостояния.Заголовок = НСтр("ru = 'Отметьте регламентные задания для выполнения на клиентском компьютере...'");
	Иначе
		Элементы.СтрокаСостояния.Заголовок = ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Отмеченные регламентные задания выполняются на этом клиентском компьютере (%1)...'"),
			Включено);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ИзменитьИспользованиеРегламентногоЗадания(Идентификатор, Выполнять)
	
	Свойства = ХранилищеОбщихНастроек.Загрузить("СостояниеРегламентногоЗадания_" + Строка(Идентификатор), , , "");
	
	Свойства = ?(ТипЗнч(Свойства) = Тип("ХранилищеЗначения"), Свойства.Получить(), Неопределено);
	Если Свойства = Неопределено Тогда
		Свойства = ПустаяТаблицаСвойствФоновыхЗаданий().Добавить();
		Свойства.ИдентификаторРегламентногоЗадания = Идентификатор;
		Свойства = СтрокаТаблицыЗначенийВСтруктуру(Свойства);
	КонецЕсли;
	Свойства.Выполнять = Выполнять;
	СохраняемоеЗначение = Новый ХранилищеЗначения(Свойства);
	ХранилищеОбщихНастроек.Сохранить("СостояниеРегламентногоЗадания_" + Строка(Идентификатор), , СохраняемоеЗначение, , "");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПрекратитьВыполнение(Команда)
	
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьКоличествоЗапусков(Команда)
	
	ТекущиеДанные = Элементы.РегламентныеЗадания.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ОчиститьКоличествоЗапусковНаСервере(ТекущиеДанные.Идентификатор);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	//
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.РегламентныеЗаданияВыполнено.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("ТаблицаРегламентныхЗаданий.Изменено");
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", Новый Цвет(128, 122, 89));
	
КонецПроцедуры

&НаСервере
Процедура ОчиститьКоличествоЗапусковНаСервере(Идентификатор)
	
	Свойства = ХранилищеОбщихНастроек.Загрузить("СостояниеРегламентногоЗадания_" + Строка(Идентификатор), , , "");
	
	Свойства = ?(ТипЗнч(Свойства) = Тип("ХранилищеЗначения"), Свойства.Получить(), Неопределено);
	Если Свойства = Неопределено Тогда
		Возврат;
	КонецЕсли;
	Свойства.ПопыткаЗапуска = 0;
	ХранилищеОбщихНастроек.Сохранить("СостояниеРегламентногоЗадания_" + Строка(Идентификатор), , Новый ХранилищеЗначения(Свойства), , "");
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьРегламентныеЗадания()
	
	ОсталосьДоНачалаВыполнения = ОсталосьДоНачалаВыполнения - 1;
	Если ОсталосьДоНачалаВыполнения <= 0 Тогда
		
		ОсталосьДоНачалаВыполнения = ИнтервалВремениПроверкиВыполнения;
		ОбновитьОтображениеДанных();
		
		ВыполнитьРегламентныеЗаданияСервер(ПараметрЗапуска);
	КонецЕсли;
	
	ПодключитьОбработчикОжидания("ВыполнитьРегламентныеЗадания", 1, Истина);
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьТаблицуРегламентныхЗаданий()
	
	УстановитьПривилегированныйРежим(Истина);
	ТекущиеЗадания = РегламентныеЗадания.ПолучитьРегламентныеЗадания();
	
	НоваяТаблицаЗаданий = РеквизитФормыВЗначение("ТаблицаРегламентныхЗаданий");
	НоваяТаблицаЗаданий.Очистить();
	
	Для Каждого Задание Из ТекущиеЗадания Цикл
		СтрокаЗадания = НоваяТаблицаЗаданий.Добавить();
		
		СтрокаЗадания.РегламентноеЗадание = ПредставлениеРегламентногоЗадания(Задание);
		СтрокаЗадания.Выполнено     = Дата(1, 1, 1);
		СтрокаЗадания.Идентификатор = Задание.УникальныйИдентификатор;
		
		СвойстваПоследнегоФоновогоЗадания = СвойстваПоследнегоФоновогоЗаданияВыполненияРегламентногоЗадания(Задание);
		
		Если СвойстваПоследнегоФоновогоЗадания <> Неопределено Тогда
			Если ЗначениеЗаполнено(СвойстваПоследнегоФоновогоЗадания.Конец) Тогда
				СтрокаЗадания.Выполнено = СвойстваПоследнегоФоновогоЗадания.Конец;
				СтрокаЗадания.Статус = Строка(СвойстваПоследнегоФоновогоЗадания.Состояние);
			КонецЕсли;
			
			СтрокаЗадания.Выполнять = СвойстваПоследнегоФоновогоЗадания.Выполнять;
		КонецЕсли;
		
		СвойстваЗадания = ТаблицаРегламентныхЗаданий.НайтиСтроки(
			Новый Структура("Идентификатор", СтрокаЗадания.Идентификатор));
		
		СтрокаЗадания.Изменено = (СвойстваЗадания = Неопределено)
		                     ИЛИ (СвойстваЗадания.Количество() = 0) 
		                     ИЛИ (СвойстваЗадания[0].Выполнено <> СтрокаЗадания.Выполнено);
	КонецЦикла;
	
	НоваяТаблицаЗаданий.Сортировать("РегламентноеЗадание");
	
	НомерЗадания = 1;
	Для Каждого СтрокаЗадания Из НоваяТаблицаЗаданий Цикл
		СтрокаЗадания.Номер = НомерЗадания;
		НомерЗадания = НомерЗадания + 1;
	КонецЦикла;
	
	ЗначениеВРеквизитФормы(НоваяТаблицаЗаданий, "ТаблицаРегламентныхЗаданий");
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьРегламентныеЗаданияСервер(ПараметрЗапуска)
#Если ТолстыйКлиентОбычноеПриложение Тогда
	ЗапуститьВыполнениеРегламентныхЗаданий(ЭтотОбъект.ТаблицаРегламентныхЗаданий);
	ОбновитьТаблицуРегламентныхЗаданий();
#КонецЕсли
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ЗапуститьВыполнениеРегламентныхЗаданий(ТаблицаРегламентныхЗаданий)
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Тогда
	ВызватьИсключениеЕслиНетПраваАдминистрирования();
	УстановитьПривилегированныйРежим(Истина);
	
	Состояние = СостояниеВыполненияРегламентныхЗаданий();
	
	ВремяВыполнения = ?(ТипЗнч(ВремяВыполнения) = Тип("Число"), ВремяВыполнения, 0);

	Задания                        = РегламентныеЗадания.ПолучитьРегламентныеЗадания();
	ВыполнениеЗавершено            = Ложь; // Определяет, что ВремяВыполнения закончилось, или
	                                       // все возможные регламентные задания выполнены.
	НачалоВыполнения               = ТекущаяДатаСеанса();
	КоличествоВыполненныхЗаданий   = 0;
	ФоновоеЗаданиеВыполнялось      = Ложь;
	ИдентификаторПоследнегоЗадания = Состояние.ИдентификаторОчередногоЗадания;

	// Количество заданий проверяется каждый раз при начале выполнения,
	// т.к. задания могут быть удалены в другом сеансе, а тогда будет зацикливание.
	Пока НЕ ВыполнениеЗавершено И Задания.Количество() > 0 Цикл
		ПервоеЗаданиеНайдено           = (ИдентификаторПоследнегоЗадания = Неопределено);
//		ОчередноеЗаданиеНайдено        = Ложь;
		Для Каждого Задание Из Задания Цикл
			ПараметрыОтбора = Новый Структура;
			ПараметрыОтбора.Вставить("Идентификатор", Задание.УникальныйИдентификатор);
			Результат = ТаблицаРегламентныхЗаданий.НайтиСтроки(ПараметрыОтбора);
			ЗаданиеВключено = Результат[0].Выполнять;
			
			// Завершение выполнения, если:
			// а) время задано и вышло;
			// б) время не задано и хоть одно фоновое задание выполнено;
			// в) время не задано и все регламентные задания выполнены по количеству.
			Если (ВремяВыполнения = 0
					И (ФоновоеЗаданиеВыполнялось
						ИЛИ КоличествоВыполненныхЗаданий >= Задания.Количество()))
				ИЛИ (ВремяВыполнения <> 0
					И НачалоВыполнения + ВремяВыполнения <= ТекущаяДатаСеанса()) Тогда
				ВыполнениеЗавершено = Истина;
				Прервать;
			КонецЕсли;
			Если НЕ ПервоеЗаданиеНайдено Тогда
				Если Строка(Задание.УникальныйИдентификатор) = ИдентификаторПоследнегоЗадания Тогда
				   // Найдено последнее выполненное регламентное задание, значит следующее
				   // регламентное задание нужно проверять на необходимость выполнения фонового задания.
				   ПервоеЗаданиеНайдено = Истина;
				КонецЕсли;
				// Если первое регламентное задание, которое нужно проверить на необходимость
				// выполнения фонового задания еще не найдено, тогда текущее задание пропускается.
				Продолжить;
			КонецЕсли;
//			ОчередноеЗаданиеНайдено = Истина;
			КоличествоВыполненныхЗаданий = КоличествоВыполненныхЗаданий + 1;
			Состояние.ИдентификаторОчередногоЗадания       = Строка(Задание.УникальныйИдентификатор);
			Состояние.НачалоВыполненияОчередногоЗадания    = ТекущаяДатаСеанса();
			Состояние.ОкончаниеВыполненияОчередногоЗадания = '00010101';
			СохранитьСостояниеВыполненияРегламентныхЗаданий(Состояние,
			                                               "ИдентификаторОчередногоЗадания,
			                                               |НачалоВыполненияОчередногоЗадания,
			                                               |ОкончаниеВыполненияОчередногоЗадания");
			Если ЗаданиеВключено Тогда
				ВыполнитьРегламентноеЗадание = Ложь;
				СвойстваПоследнегоФоновогоЗадания = СвойстваПоследнегоФоновогоЗаданияВыполненияРегламентногоЗадания(Задание);
				
				Если СвойстваПоследнегоФоновогоЗадания <> Неопределено
					И СвойстваПоследнегоФоновогоЗадания.Состояние = СостояниеФоновогоЗадания.ЗавершеноАварийно Тогда
					// Проверка аварийного расписания.
					Если СвойстваПоследнегоФоновогоЗадания.ПопыткаЗапуска <= Задание.КоличествоПовторовПриАварийномЗавершении Тогда
						Если СвойстваПоследнегоФоновогоЗадания.Конец + Задание.ИнтервалПовтораПриАварийномЗавершении <= ТекущаяДатаСеанса() Тогда
						    // Повторный запуск фонового задания по регламентному заданию.
						    ВыполнитьРегламентноеЗадание = Истина;
						КонецЕсли;
					КонецЕсли;
				Иначе
					// Проверяем стандартное расписание.
					ВыполнитьРегламентноеЗадание = Задание.Расписание.ТребуетсяВыполнение(
						ТекущаяДатаСеанса(),
						?(СвойстваПоследнегоФоновогоЗадания = Неопределено, '00010101', СвойстваПоследнегоФоновогоЗадания.Начало),
						?(СвойстваПоследнегоФоновогоЗадания = Неопределено, '00010101', СвойстваПоследнегоФоновогоЗадания.Конец ));
				КонецЕсли;
				Если ВыполнитьРегламентноеЗадание Тогда
					ФоновоеЗаданиеВыполнялось = ВыполнитьРегламентноеЗадание(Задание);
				КонецЕсли;
			КонецЕсли;
			Состояние.ОкончаниеВыполненияОчередногоЗадания = ТекущаяДатаСеанса();
			СохранитьСостояниеВыполненияРегламентныхЗаданий(Состояние, "ОкончаниеВыполненияОчередногоЗадания");
		КонецЦикла;
		// Если последнее выполненное задание найти не удалось, тогда
		// его Идентификатор сбрасывается,
		// чтобы начать проверку регламентных заданий, начиная с первого.
		ИдентификаторПоследнегоЗадания = Неопределено;
	КонецЦикла;
	
#КонецЕсли
КонецПроцедуры

&НаСервереБезКонтекста
Функция ВыполнитьРегламентноеЗадание(Знач Задание)
	ЗапускВручную = Ложь;
	МоментЗапуска = Неопределено;
	МоментОкончания = Неопределено;
	//@skip-warning
	НомерСеанса = Неопределено;
	//@skip-warning
	НачалоСеанса = Неопределено;
//	
	СвойстваПоследнегоФоновогоЗадания = СвойстваПоследнегоФоновогоЗаданияВыполненияРегламентногоЗадания(Задание);
	
	Если СвойстваПоследнегоФоновогоЗадания <> Неопределено
	   И СвойстваПоследнегоФоновогоЗадания.Состояние = СостояниеФоновогоЗадания.Активно Тогда
		
		НомерСеанса  = СвойстваПоследнегоФоновогоЗадания.НомерСеанса;
		НачалоСеанса = СвойстваПоследнегоФоновогоЗадания.НачалоСеанса;
		Возврат Ложь;
	КонецЕсли;
	
	ИмяМетода = Задание.Метаданные.ИмяМетода;
	НаименованиеФоновогоЗадания = ПодставитьПараметрыВСтроку(
		?(ЗапускВручную,
		  НСтр("ru = 'Запуск вручную: %1'"),
		  НСтр("ru = 'Автозапуск: %1'")),
		ПредставлениеРегламентногоЗадания(Задание));
	
	МоментЗапуска = ?(ТипЗнч(МоментЗапуска) <> Тип("Дата") ИЛИ НЕ ЗначениеЗаполнено(МоментЗапуска), ТекущаяДатаСеанса(), МоментЗапуска);
	
	// Создание свойств нового фонового псевдо-задания.
	СвойстваФоновогоЗадания = ПустаяТаблицаСвойствФоновыхЗаданий().Добавить();
	СвойстваФоновогоЗадания.Выполнять = СвойстваПоследнегоФоновогоЗадания.Выполнять;
	СвойстваФоновогоЗадания.Идентификатор  = Строка(Новый УникальныйИдентификатор());
	СвойстваФоновогоЗадания.ПопыткаЗапуска = ?(
		СвойстваПоследнегоФоновогоЗадания <> Неопределено
		И СвойстваПоследнегоФоновогоЗадания.Состояние = СостояниеФоновогоЗадания.ЗавершеноАварийно,
		СвойстваПоследнегоФоновогоЗадания.ПопыткаЗапуска + 1,
		1);
	СвойстваФоновогоЗадания.Наименование                      = НаименованиеФоновогоЗадания;
	СвойстваФоновогоЗадания.ИдентификаторРегламентногоЗадания = Строка(Задание.УникальныйИдентификатор);
	СвойстваФоновогоЗадания.Расположение                      = "\\" + ИмяКомпьютера();
	СвойстваФоновогоЗадания.ИмяМетода                         = ИмяМетода;
	СвойстваФоновогоЗадания.Состояние                         = СостояниеФоновогоЗадания.Активно;
	СвойстваФоновогоЗадания.Начало                            = МоментЗапуска;
	СвойстваФоновогоЗадания.НомерСеанса                       = НомерСеансаИнформационнойБазы();
	
	Для Каждого Сеанс Из ПолучитьСеансыИнформационнойБазы() Цикл
		Если Сеанс.НомерСеанса = СвойстваФоновогоЗадания.НомерСеанса Тогда
			СвойстваФоновогоЗадания.НачалоСеанса = Сеанс.НачалоСеанса;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	// Сохранение информации о запуске.
	СохраняемоеЗначение = Новый ХранилищеЗначения(СтрокаТаблицыЗначенийВСтруктуру(СвойстваФоновогоЗадания));
	ХранилищеОбщихНастроек.Сохранить("СостояниеРегламентногоЗадания_" + Строка(Задание.УникальныйИдентификатор), , СохраняемоеЗначение, , "");
	
	ПолучитьСообщенияПользователю(Истина);
	Попытка
		// Здесь нет возможности выполнения произвольного кода, т.к. метод берется из метаданных регламентного задания.
		ВыполнитьМетодКонфигурации(ИмяМетода, Задание.Параметры);
		СвойстваФоновогоЗадания.Состояние = СостояниеФоновогоЗадания.Завершено;
	Исключение
		СвойстваФоновогоЗадания.Состояние = СостояниеФоновогоЗадания.ЗавершеноАварийно;
		СвойстваФоновогоЗадания.ОписаниеИнформацииОбОшибке = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
	КонецПопытки;
	
	// Фиксация окончания выполнения метода.
	МоментОкончания = ТекущаяДатаСеанса();
	СвойстваФоновогоЗадания.Конец = МоментОкончания;
	СвойстваФоновогоЗадания.СообщенияПользователю = Новый Массив;
	Для Каждого Сообщение Из ПолучитьСообщенияПользователю() Цикл
		СвойстваФоновогоЗадания.СообщенияПользователю.Добавить(Сообщение);
	КонецЦикла;
	ПолучитьСообщенияПользователю(Истина);
	
	Свойства = ХранилищеОбщихНастроек.Загрузить("СостояниеРегламентногоЗадания_" + Строка(Задание.УникальныйИдентификатор), , , "");
	Свойства = ?(ТипЗнч(Свойства) = Тип("ХранилищеЗначения"), Свойства.Получить(), Неопределено);
	
	Если ТипЗнч(Свойства) <> Тип("Структура")
	 ИЛИ НЕ Свойства.Свойство("НомерСеанса")
	 ИЛИ НЕ Свойства.Свойство("НачалоСеанса")
	 ИЛИ(  Свойства.НомерСеанса  = СвойстваФоновогоЗадания.НомерСеанса
	     И Свойства.НачалоСеанса = СвойстваФоновогоЗадания.НачалоСеанса) Тогда
		// Маловероятной перезаписи из-за отсутствия блокировки не произошло, поэтому можно записать свойства.
		СохраняемоеЗначение = Новый ХранилищеЗначения(СтрокаТаблицыЗначенийВСтруктуру(СвойстваФоновогоЗадания));
		ХранилищеОбщихНастроек.Сохранить("СостояниеРегламентногоЗадания_" + Строка(Задание.УникальныйИдентификатор), , СохраняемоеЗначение, , "");
	КонецЕсли;
	
	Возврат Истина;
КонецФункции

&НаСервереБезКонтекста
Функция СостояниеВыполненияРегламентныхЗаданий()
	// Подготовка данных для проверки или начальной установки свойств прочитанного состояния.
	НоваяСтруктура = Новый Структура();
	// Хранение истории выполнения фоновых заданий.
	НоваяСтруктура.Вставить("НомерСеанса",                          0);
	НоваяСтруктура.Вставить("НачалоСеанса",                         '00010101');
	НоваяСтруктура.Вставить("ИмяКомпьютера",                        "");
	НоваяСтруктура.Вставить("ИмяПриложения",                        "");
	НоваяСтруктура.Вставить("ИмяПользователя",                      "");
	НоваяСтруктура.Вставить("ИдентификаторОчередногоЗадания",       "");
	НоваяСтруктура.Вставить("НачалоВыполненияОчередногоЗадания",    '00010101');
	НоваяСтруктура.Вставить("ОкончаниеВыполненияОчередногоЗадания", '00010101');
	
	Состояние = ХранилищеОбщихНастроек.Загрузить("СостояниеВыполненияРегламентныхЗаданий", , , "");
	Состояние = ?(ТипЗнч(Состояние) = Тип("ХранилищеЗначения"), Состояние.Получить(), Неопределено);
	
	// Копирование существующих свойств.
	Если ТипЗнч(Состояние) = Тип(НоваяСтруктура) Тогда
		Для Каждого КлючИЗначение Из НоваяСтруктура Цикл
			Если Состояние.Свойство(КлючИЗначение.Ключ) Тогда
				Если ТипЗнч(НоваяСтруктура[КлючИЗначение.Ключ]) = ТипЗнч(Состояние[КлючИЗначение.Ключ]) Тогда
					НоваяСтруктура[КлючИЗначение.Ключ] = Состояние[КлючИЗначение.Ключ];
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Возврат НоваяСтруктура;
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура СохранитьСостояниеВыполненияРегламентныхЗаданий(Состояние, Знач ИзмененныеСвойства = Неопределено)
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Тогда
	Если ИзмененныеСвойства <> Неопределено Тогда
		ТекущееСостояние = СостояниеВыполненияРегламентныхЗаданий();
		ЗаполнитьЗначенияСвойств(ТекущееСостояние, Состояние, ИзмененныеСвойства);
		Состояние = ТекущееСостояние;
	КонецЕсли;
	
	ХранилищеОбщихНастроек.Сохранить("СостояниеВыполненияРегламентныхЗаданий", , Новый ХранилищеЗначения(Состояние), , "");
#КонецЕсли
КонецПроцедуры

&НаСервереБезКонтекста
Функция СвойстваПоследнегоФоновогоЗаданияВыполненияРегламентногоЗадания(РегламентноеЗадание)
	ВызватьИсключениеЕслиНетПраваАдминистрирования();
	УстановитьПривилегированныйРежим(Истина);
	
	ИдентификаторРегламентногоЗадания = ?(ТипЗнч(РегламентноеЗадание) = Тип("РегламентноеЗадание"), Строка(РегламентноеЗадание.УникальныйИдентификатор), РегламентноеЗадание);
	Отбор = Новый Структура;
	Отбор.Вставить("ИдентификаторРегламентногоЗадания", ИдентификаторРегламентногоЗадания);
	Отбор.Вставить("ПолучитьПоследнееФоновоеЗаданиеРегламентногоЗадания");
	ТаблицаСвойствФоновыхЗаданий = СвойствФоновыхЗаданий(Отбор);
	ТаблицаСвойствФоновыхЗаданий.Сортировать("Конец Возр");
	
	Если ТаблицаСвойствФоновыхЗаданий.Количество() = 0 Тогда
		СвойстваФоновогоЗадания = Неопределено;
	ИначеЕсли НЕ ЗначениеЗаполнено(ТаблицаСвойствФоновыхЗаданий[0].Конец) Тогда
		СвойстваФоновогоЗадания = ТаблицаСвойствФоновыхЗаданий[0];
	Иначе
		СвойстваФоновогоЗадания = ТаблицаСвойствФоновыхЗаданий[ТаблицаСвойствФоновыхЗаданий.Количество()-1];
	КонецЕсли;
	
	СохраняемоеЗначение = Новый ХранилищеЗначения(?(СвойстваФоновогоЗадания = Неопределено, Неопределено, СтрокаТаблицыЗначенийВСтруктуру(СвойстваФоновогоЗадания)));
	ХранилищеОбщихНастроек.Сохранить("СостояниеРегламентногоЗадания_" + ИдентификаторРегламентногоЗадания, , СохраняемоеЗначение, , "");
	
	Возврат СвойстваФоновогоЗадания;
КонецФункции

&НаСервереБезКонтекста
Функция СвойствФоновыхЗаданий(Отбор = Неопределено)
	ВызватьИсключениеЕслиНетПраваАдминистрирования();
	УстановитьПривилегированныйРежим(Истина);
	
	Таблица = ПустаяТаблицаСвойствФоновыхЗаданий();
	
	Если Отбор <> Неопределено И Отбор.Свойство("ПолучитьПоследнееФоновоеЗаданиеРегламентногоЗадания") Тогда
		Отбор.Удалить("ПолучитьПоследнееФоновоеЗаданиеРегламентногоЗадания");
		//@skip-warning
		ПолучитьПоследнее = Истина;
	Иначе
		ПолучитьПоследнее = Ложь;
	КонецЕсли;
	
	РегламентноеЗадание = Неопределено;
	
	Если Отбор <> Неопределено И Отбор.Свойство("ИдентификаторРегламентногоЗадания") Тогда
		РегламентныеЗаданияДляОбработки = Новый Массив;
		Если Отбор.ИдентификаторРегламентногоЗадания <> "" Тогда
			Если РегламентноеЗадание = Неопределено Тогда
				РегламентноеЗадание = РегламентныеЗадания.НайтиПоУникальномуИдентификатору(Новый УникальныйИдентификатор(Отбор.ИдентификаторРегламентногоЗадания));
			КонецЕсли;
			Если РегламентноеЗадание <> Неопределено Тогда
				РегламентныеЗаданияДляОбработки.Добавить(РегламентноеЗадание);
			КонецЕсли;
		КонецЕсли;
	Иначе
		РегламентныеЗаданияДляОбработки = РегламентныеЗадания.ПолучитьРегламентныеЗадания();
	КонецЕсли;
	
	// Добавление и сохранение состояний регламентных заданий
	Для Каждого РегламентноеЗадание Из РегламентныеЗаданияДляОбработки Цикл
		ИдентификаторРегламентногоЗадания = Строка(РегламентноеЗадание.УникальныйИдентификатор);
		Свойства = ХранилищеОбщихНастроек.Загрузить("СостояниеРегламентногоЗадания_" + ИдентификаторРегламентногоЗадания, , , "");
		Свойства = ?(ТипЗнч(Свойства) = Тип("ХранилищеЗначения"), Свойства.Получить(), Неопределено);
		
		Если ТипЗнч(Свойства) = Тип("Структура")
		   И Свойства.ИдентификаторРегламентногоЗадания = ИдентификаторРегламентногоЗадания
		   И Таблица.НайтиСтроки(Новый Структура("Идентификатор, НаСервере", Свойства.Идентификатор, Свойства.НаСервере)).Количество() = 0 Тогда
			
			Если Свойства.НаСервере Тогда
				ХранилищеОбщихНастроек.Сохранить("СостояниеРегламентногоЗадания_" + ИдентификаторРегламентногоЗадания, , Неопределено, , "");
			Иначе
				Если Свойства.Состояние = СостояниеФоновогоЗадания.Активно Тогда
					НайденСеансВыполняющийЗадания = Ложь;
					Для Каждого Сеанс Из ПолучитьСеансыИнформационнойБазы() Цикл
						Если Сеанс.НомерСеанса  = Свойства.НомерСеанса
						   И Сеанс.НачалоСеанса = Свойства.НачалоСеанса Тогда
							НайденСеансВыполняющийЗадания = НомерСеансаИнформационнойБазы() <> Сеанс.НомерСеанса;
							Прервать;
						КонецЕсли;
					КонецЦикла;
					Если НЕ НайденСеансВыполняющийЗадания Тогда
						Свойства.Конец = ТекущаяДатаСеанса();
						Свойства.Состояние = СостояниеФоновогоЗадания.ЗавершеноАварийно;
						Свойства.ОписаниеИнформацииОбОшибке = НСтр("ru = 'Не найден сеанс, выполняющий процедуру регламентного задания.'");
					КонецЕсли;
				КонецЕсли;
				ЗаполнитьЗначенияСвойств(Таблица.Добавить(), Свойства);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	Таблица.Сортировать("Начало Убыв, Конец Убыв");
	
	// Отбор фоновых заданий.
	Если Отбор <> Неопределено Тогда
		Начало    = Неопределено;
		Конец     = Неопределено;
		Состояние = Неопределено;
		Если Отбор.Свойство("Начало") Тогда
			Начало = ?(ЗначениеЗаполнено(Отбор.Начало), Отбор.Начало, Неопределено);
			Отбор.Удалить("Начало");
		КонецЕсли;
		Если Отбор.Свойство("Конец") Тогда
			Конец = ?(ЗначениеЗаполнено(Отбор.Конец), Отбор.Конец, Неопределено);
			Отбор.Удалить("Конец");
		КонецЕсли;
		Если Отбор.Свойство("Состояние") Тогда
			Если ТипЗнч(Отбор.Состояние) = Тип("Массив") Тогда
				Состояние = Отбор.Состояние;
				Отбор.Удалить("Состояние");
			КонецЕсли;
		КонецЕсли;
		
		Если Отбор.Количество() <> 0 Тогда
			Строки = Таблица.НайтиСтроки(Отбор);
		Иначе
			Строки = Таблица;
		КонецЕсли;
		// Выполнение дополнительной фильтрации по периоду и состоянию (если отбор определен).
		НомерЭлемента = Строки.Количество() - 1;
		Пока НомерЭлемента >= 0 Цикл
			Если Начало    <> Неопределено И Начало > Строки[НомерЭлемента].Начало
				ИЛИ Конец     <> Неопределено И Конец  < ?(ЗначениеЗаполнено(Строки[НомерЭлемента].Конец), Строки[НомерЭлемента].Конец, ТекущаяДатаСеанса())
				ИЛИ Состояние <> Неопределено И Состояние.Найти(Строки[НомерЭлемента].Состояние) = Неопределено Тогда
				Строки.Удалить(НомерЭлемента);
			КонецЕсли;
			НомерЭлемента = НомерЭлемента - 1;
		КонецЦикла;
		// Удаление лишних строк из таблицы.
		Если ТипЗнч(Строки) = Тип("Массив") Тогда
			НомерСтроки = Таблица.Количество() - 1;
			Пока НомерСтроки >= 0 Цикл
				Если Строки.Найти(Таблица[НомерСтроки]) = Неопределено Тогда
					Таблица.Удалить(Таблица[НомерСтроки]);
				КонецЕсли;
				НомерСтроки = НомерСтроки - 1;
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;
	
	Возврат Таблица;
КонецФункции

&НаСервереБезКонтекста
Функция ПустаяТаблицаСвойствФоновыхЗаданий()
	НоваяТаблица = Новый ТаблицаЗначений;
	НоваяТаблица.Колонки.Добавить("НаСервере",                         Новый ОписаниеТипов("Булево"));
	НоваяТаблица.Колонки.Добавить("Идентификатор",                     Новый ОписаниеТипов("Строка"));
	НоваяТаблица.Колонки.Добавить("Наименование",                      Новый ОписаниеТипов("Строка"));
	НоваяТаблица.Колонки.Добавить("Ключ",                              Новый ОписаниеТипов("Строка"));
	НоваяТаблица.Колонки.Добавить("Начало",                            Новый ОписаниеТипов("Дата"));
	НоваяТаблица.Колонки.Добавить("Конец",                             Новый ОписаниеТипов("Дата"));
	НоваяТаблица.Колонки.Добавить("ИдентификаторРегламентногоЗадания", Новый ОписаниеТипов("Строка"));
	НоваяТаблица.Колонки.Добавить("Состояние",                         Новый ОписаниеТипов("СостояниеФоновогоЗадания"));
	НоваяТаблица.Колонки.Добавить("ИмяМетода",                         Новый ОписаниеТипов("Строка"));
	НоваяТаблица.Колонки.Добавить("Расположение",                      Новый ОписаниеТипов("Строка"));
	НоваяТаблица.Колонки.Добавить("ОписаниеИнформацииОбОшибке",        Новый ОписаниеТипов("Строка"));
	НоваяТаблица.Колонки.Добавить("ПопыткаЗапуска",                    Новый ОписаниеТипов("Число"));
	НоваяТаблица.Колонки.Добавить("СообщенияПользователю",             Новый ОписаниеТипов("Массив"));
	НоваяТаблица.Колонки.Добавить("НомерСеанса",                       Новый ОписаниеТипов("Число"));
	НоваяТаблица.Колонки.Добавить("НачалоСеанса",                      Новый ОписаниеТипов("Дата"));
	НоваяТаблица.Колонки.Добавить("Выполнять",                         Новый ОписаниеТипов("Булево"));
	НоваяТаблица.Индексы.Добавить("Идентификатор, Начало");
	
	Возврат НоваяТаблица;
КонецФункции

&НаСервереБезКонтекста
Функция ПредставлениеРегламентногоЗадания(Знач Задание) Экспорт
	ВызватьИсключениеЕслиНетПраваАдминистрирования();
	
	Если ТипЗнч(Задание) = Тип("РегламентноеЗадание") Тогда
		РегламентноеЗадание = Задание;
	Иначе
		РегламентноеЗадание = РегламентныеЗадания.НайтиПоУникальномуИдентификатору(Новый УникальныйИдентификатор(Задание));
	КонецЕсли;
	
	Если РегламентноеЗадание <> Неопределено Тогда
		Представление = РегламентноеЗадание.Наименование;
		
		Если ПустаяСтрока(РегламентноеЗадание.Наименование) Тогда
			Представление = РегламентноеЗадание.Метаданные.Синоним;
			
			Если ПустаяСтрока(Представление) Тогда
				Представление = РегламентноеЗадание.Метаданные.Имя;
			КонецЕсли
		КонецЕсли;
	Иначе
		Представление = НСтр("ru = '<не определено>'");
	КонецЕсли;
	
	Возврат Представление;
КонецФункции

&НаСервереБезКонтекста
Процедура ВызватьИсключениеЕслиНетПраваАдминистрирования() Экспорт
	
	Если НЕ ПривилегированныйРежим() Тогда
		ВыполнитьПроверкуПравДоступа("Администрирование", Метаданные);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ПодставитьПараметрыВСтроку(Знач СтрокаПодстановки,
	Знач Параметр1, Знач Параметр2 = Неопределено, Знач Параметр3 = Неопределено,
	Знач Параметр4 = Неопределено, Знач Параметр5 = Неопределено, Знач Параметр6 = Неопределено,
	Знач Параметр7 = Неопределено, Знач Параметр8 = Неопределено, Знач Параметр9 = Неопределено) Экспорт
	
	СтрокаПодстановки = СтрЗаменить(СтрокаПодстановки, "%1", Параметр1);
	СтрокаПодстановки = СтрЗаменить(СтрокаПодстановки, "%2", Параметр2);
	СтрокаПодстановки = СтрЗаменить(СтрокаПодстановки, "%3", Параметр3);
	СтрокаПодстановки = СтрЗаменить(СтрокаПодстановки, "%4", Параметр4);
	СтрокаПодстановки = СтрЗаменить(СтрокаПодстановки, "%5", Параметр5);
	СтрокаПодстановки = СтрЗаменить(СтрокаПодстановки, "%6", Параметр6);
	СтрокаПодстановки = СтрЗаменить(СтрокаПодстановки, "%7", Параметр7);
	СтрокаПодстановки = СтрЗаменить(СтрокаПодстановки, "%8", Параметр8);
	СтрокаПодстановки = СтрЗаменить(СтрокаПодстановки, "%9", Параметр9);
	
	Возврат СтрокаПодстановки;
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура ВыполнитьМетодКонфигурации(Знач ИмяМетода, Знач Параметры = Неопределено)
	
	ПараметрыСтрока = "";
	Если Параметры <> Неопределено И Параметры.Количество() > 0 Тогда
		Для Индекс = 0 По Параметры.ВГраница() Цикл 
			ПараметрыСтрока = ПараметрыСтрока + "Параметры[" + Индекс + "],";
		КонецЦикла;
		ПараметрыСтрока = Сред(ПараметрыСтрока, 1, СтрДлина(ПараметрыСтрока) - 1);
	КонецЕсли;
	
	Выполнить ИмяМетода + "(" + ПараметрыСтрока + ")";
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция СтрокаТаблицыЗначенийВСтруктуру(СтрокаТаблицыЗначений)
	
	Структура = Новый Структура;
	Для каждого Колонка Из СтрокаТаблицыЗначений.Владелец().Колонки Цикл
		Структура.Вставить(Колонка.Имя, СтрокаТаблицыЗначений[Колонка.Имя]);
	КонецЦикла;
	
	Возврат Структура;
	
КонецФункции

#КонецОбласти