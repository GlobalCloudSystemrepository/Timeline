global with sharing class MyEventTimelineProvider extends timeline.AbstractTimelineDataProvider {

    global override String getObjectName() {
        return 'Event';
    }

    global override String getRelationshipName() {
        return 'Events';
    }

    global override String getTitleField() {
        return 'Subject';
    }

    global override String getDateField() {
        return 'ActivityDate';
    }

    global override List<String> getFieldsToDisplay() {
        return new List<String>{ 'Subject', 'CreatedDate', 'ActivityDate', 'IsArchived' };
    }

    global override String getBaseUrlForRecordDetail() {
        return '';
    }

    global override String getRecordIdentifierField() {
        return 'Id';
    }

    global override List<Object> getData(Id recordId, String dateFilter) {
        List<Object> results = new List<Object>();

        String soql = 'SELECT Id, Subject, CreatedDate, ActivityDate, IsArchived, Owner.Name, Who.Name ' +
                      'FROM Event WHERE WhatId = \'' + String.escapeSingleQuotes(recordId) + '\' ' +
                      'ORDER BY ActivityDate DESC ALL ROWS';

        List<Event> eventList = (List<Event>) Database.query(soql);

        for (Event e : eventList) {
            Map<String, Object> obj = new Map<String, Object>{
                'Id' => e.Id,
                'Subject' => e.Subject,
                'CreatedDate' => e.CreatedDate,
                'ActivityDate' => e.ActivityDate,
                'IsArchived' => e.IsArchived,
                'Owner' => new Map<String, Object>{ 'Name' => e.Owner != null ? e.Owner.Name : null }
            };
            if (e.WhoId != null) {
                obj.put('Who', new Map<String, Object>{ 'Name' => e.Who != null ? e.Who.Name : null });
            }
            results.add(obj);
        }

        return results;
    }

    global override Boolean isSalesforceObject() { return true; }
    global override Boolean isUiApiNotSupported() { return true; }
}
