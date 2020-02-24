import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lunasea/core.dart';
import './entry.dart';

class SABnzbdAPI extends API {
    final Map<String, dynamic> _values;

    SABnzbdAPI._internal(this._values);
    factory SABnzbdAPI.from(ProfileHiveObject profile) => SABnzbdAPI._internal(profile.getSABnzbd());

    void logWarning(String methodName, String text) => Logger.warning('package:lunasea/logic/clients/sabnzbd/api.dart', methodName, 'SABnzbd: $text');
    void logError(String methodName, String text, Object error) => Logger.error('package:lunasea/logic/clients/sabnzbd/api.dart', methodName, 'SABnzbd: $text', error, StackTrace.current);

    bool get enabled => _values['enabled'];
    String get host => _values['host'];
    String get key => _values['key'];
    
    Future<bool> testConnection() async {
        try {
            String uri = '$host/api?mode=fullstatus&output=json&apikey=$key';
            http.Response response = await http.get(
                Uri.encodeFull(uri),
            );
            if(response.statusCode == 200) {
                Map body = json.decode(response.body);
                if(body['status'] != false) {
                    return true;
                }
            }
        } catch (e) {
            logError('testConnection', 'Connection test failed', e);
            return false;
        }
        logWarning('testConnection', 'Connection test failed');
        return false;
    }

    Future<SABnzbdStatisticsEntry> getStatistics() async {
        try {
            String uriStatus = '$host/api?mode=fullstatus&skip_dashboard=1&output=json&apikey=$key';
            String uriStatistics = '$host/api?mode=server_stats&output=json&apikey=$key';
            http.Response status = await http.get(
                Uri.encodeFull(uriStatus),
            );
            http.Response statistics = await http.get(
                Uri.encodeFull(uriStatistics),
            );
            if(status.statusCode == 200 && statistics.statusCode == 200) {
                Map statusBody = json.decode(status.body);
                Map statisticsBody = json.decode(statistics.body);
                if(statusBody['status'] != false && statisticsBody['status'] == null) {
                    List<String> _servers = [];
                    for(var server in statusBody['status']['servers']) {
                        if(server['servername'] != null) {
                            _servers.add(server['servername']);
                        }
                    }
                    return SABnzbdStatisticsEntry(
                        _servers,
                        statusBody['status']['uptime'] ?? 'Unknown',
                        statusBody['status']['version'] ?? 'Unknown',
                        statusBody['status']['speedlimit_abs'] == '' ? -1 : double.tryParse(statusBody['status']['speedlimit_abs']),
                        int.tryParse(statusBody['status']['speedlimit']) ?? 100,
                        double.tryParse(statusBody['status']['diskspace1']) ?? 0.0,
                        statisticsBody['day'] ?? 0,
                        statisticsBody['week'] ?? 0,
                        statisticsBody['month'] ?? 0,
                        statisticsBody['total'] ?? 0,
                    );
                }
            } else {
                logError('getStatistics', '<GET> HTTP Status Code(s) (${status.statusCode}, ${statistics.statusCode})', null);
            }
        } catch (e) {
            logError('getStatistics', 'Failed to fetch statistics', e);
            return null;
        }
        logWarning('getStatistics', 'Failed to fetch statistics');
        return null;
    }

    Future<bool> pauseQueue() async {
        try {
            String uri = '$host/api?mode=pause&output=json&apikey=$key';
            http.Response response = await http.get(
                Uri.encodeFull(uri),
            );
            if(response.statusCode == 200) {
                Map body = json.decode(response.body);
                if(body['status'] != null && body['status']) {
                    return true;
                }
            } else {
                logError('pauseQueue', '<GET> HTTP Status Code (${response.statusCode})', null);
            }
        } catch (e) {
            logError('pauseQueue', 'Failed to pause queue', e);
            return false;
        }
        logWarning('pauseQueue', 'Failed to pause queue');
        return false;
    }

    Future<bool> pauseQueueFor(int minutes) async {
        try {
            String uri = '$host/api?mode=config&name=set_pause&value=$minutes&output=json&apikey=$key';
            http.Response response = await http.get(
                Uri.encodeFull(uri),
            );
            if(response.statusCode == 200) {
                Map body = json.decode(response.body);
                if(body['status'] != null && body['status']) {
                    return true;
                }
            } else {
                logError('pauseQueueFor', '<GET> HTTP Status Code (${response.statusCode})', null);
            }
        } catch (e) {
            logError('pauseQueueFor', 'Failed to pause queue for $minutes minutes', e);
            return false;
        }
        logWarning('pauseQueueFor', 'Failed to pause queue for $minutes minutes');
        return false;
    }

    Future<bool> resumeQueue() async {
        try {
            String uri = '$host/api?mode=resume&output=json&apikey=$key';
            http.Response response = await http.get(
                Uri.encodeFull(uri),
            );
            if(response.statusCode == 200) {
                Map body = json.decode(response.body);
                if(body['status'] != null && body['status']) {
                    return true;
                }
            } else {
                logError('resumeQueue', '<GET> HTTP Status Code (${response.statusCode})', null);
            }
        } catch (e) {
            logError('resumeQueue', 'Failed to resume queue', e);
            return false;
        }
        logWarning('resumeQueue', 'Failed to resume queue');
        return false;
    }

    Future<bool> pauseSingleJob(String nzoId) async {
        try {
            String uri = '$host/api?mode=queue&name=pause&value=$nzoId&output=json&apikey=$key';
            http.Response response = await http.get(
                Uri.encodeFull(uri),
            );
            if(response.statusCode == 200) {
                Map body = json.decode(response.body);
                if(body['status'] != null && body['status']) {
                    return true;
                }
            } else {
                logError('pauseSingleJob', '<GET> HTTP Status Code (${response.statusCode})', null);
            }
        } catch (e) {
            logError('pauseSingleJob', 'Failed to pause job ($nzoId)', e);
            return false;
        }
        logWarning('pauseSingleJob', 'Failed to pause job ($nzoId)');
        return false;
    }

    Future<bool> resumeSingleJob(String nzoId) async {
        try {
            String uri = '$host/api?mode=queue&name=resume&value=$nzoId&output=json&apikey=$key';
            http.Response response = await http.get(
                Uri.encodeFull(uri),
            );
            if(response.statusCode == 200) {
                Map body = json.decode(response.body);
                if(body['status'] != null && body['status']) {
                    return true;
                }
            } else {
                logError('resumeSingleJob', '<GET> HTTP Status Code (${response.statusCode})', null);
            }
        } catch (e) {
            logError('resumeSingleJob', 'Failed to resume job ($nzoId)', e);
            return false;
        }
        logWarning('resumeSingleJob', 'Failed to resume job ($nzoId)');
        return false;
    }

    Future<bool> deleteJob(String nzoId) async {
        try {
            String uri = '$host/api?mode=queue&name=delete&value=$nzoId&del_files=1&output=json&apikey=$key';
            http.Response response = await http.get(
                Uri.encodeFull(uri),
            );
            if(response.statusCode == 200) {
                Map body = json.decode(response.body);
                if(body['status'] != null && body['status']) {
                    return true;
                }
            } else {
                logError('deleteJob', '<GET> HTTP Status Code (${response.statusCode})', null);
            }
        } catch (e) {
            logError('deleteJob', 'Failed to delete job ($nzoId)', e);
            return false;
        }
        logWarning('deleteJob', 'Failed to delete job ($nzoId)');
        return false;
    }

    Future<bool> renameJob(String nzoId, String name) async {
        try {
            String uri = '$host/api?mode=queue&name=rename&value=$nzoId&value2=$name&output=json&apikey=$key';
            http.Response response = await http.get(
                Uri.encodeFull(uri),
            );
            if(response.statusCode == 200) {
                Map body = json.decode(response.body);
                if(body['status'] != null && body['status']) {
                    return true;
                }
            } else {
                logError('renameJob', '<GET> HTTP Status Code (${response.statusCode})', null);
            }
        } catch (e) {
            logError('renameJob', 'Failed to rename job ($nzoId, $name)', e);
            return false;
        }
        logWarning('renameJob', 'Failed to rename job ($nzoId, $name)');
        return false;
    }

    Future<bool> setJobPassword(String nzoId, String name, String password) async {
        try {
            String uri = '$host/api?mode=queue&name=rename&value=$nzoId&value2=$name&value3=$password&output=json&apikey=$key';
            http.Response response = await http.get(
                Uri.encodeFull(uri),
            );
            if(response.statusCode == 200) {
                Map body = json.decode(response.body);
                if(body['status'] != null && body['status']) {
                    return true;
                }
            } else {
                logError('setJobPassword', '<GET> HTTP Status Code (${response.statusCode})', null);
            }
        } catch (e) {
            logError('setJobPassword', 'Failed to set job password ($nzoId, $password)', e);
            return false;
        }
        logWarning('setJobPassword', 'Failed to set job password ($nzoId, $password)');
        return false;
    }

    Future<bool> setJobPriority(String nzoId, int priority) async {
        try {
            String uri = '$host/api?mode=queue&name=priority&value=$nzoId&value2=$priority&output=json&apikey=$key';
            http.Response response = await http.get(
                Uri.encodeFull(uri),
            );
            if(response.statusCode == 200) {
                Map body = json.decode(response.body);
                if(body['position'] != null && body['position'] != -1) {
                    return true;
                }
            } else {
                logError('setJobPriority', '<GET> HTTP Status Code (${response.statusCode})', null);
            }
        } catch (e) {
            logError('setJobPriority', 'Failed to set job priority ($nzoId, $priority)', e);
            return false;
        }
        logWarning('setJobPriority', 'Failed to set job priority ($nzoId, $priority)');
        return false;
    }

    Future<bool> deleteHistory(String nzoId) async {
        try {
            String uri = '$host/api?mode=history&name=delete&del_files=1&value=$nzoId&output=json&apikey=$key';
            http.Response response = await http.get(
                Uri.encodeFull(uri),
            );
            if(response.statusCode == 200) {
                Map body = json.decode(response.body);
                if(body['status'] != null && body['status']) {
                    return true;
                }
            } else {
                logError('deleteHistory', '<GET> HTTP Status Code (${response.statusCode})', null);
            }
        } catch (e) {
            logError('deleteHistory', 'Failed to delete history entry ($nzoId)', e);
            return false;
        }
        logWarning('deleteHistory', 'Failed to delete history entry ($nzoId)');
        return false;
    }

    Future<List<dynamic>> getStatusAndQueue() async {
        try {
            String uri = '$host/api?mode=queue&output=json&apikey=$key';
            http.Response response = await http.get(
                Uri.encodeFull(uri),
            );
            if(response.statusCode == 200) {
                Map body = json.decode(response.body);
                if(body['status'] == null || body['status']) {
                    SABnzbdStatusEntry status = SABnzbdStatusEntry(
                        body['queue']['paused'] ?? false,
                        double.tryParse(body['queue']['kbpersec']) ?? 0.0,
                        double.tryParse(body['queue']['mbleft']) ?? 0.0,
                        body['queue']['timeleft'] ?? '00:00:00',
                        int.tryParse(body['queue']['speedlimit']) ?? 0,
                    );
                    List<SABnzbdQueueEntry> queue = [];
                    for(var entry in body['queue']['slots']) {
                        queue.add(SABnzbdQueueEntry(
                            entry['filename'] ?? '',
                            entry['nzo_id'] ?? '',
                            double.tryParse(entry['mb'])?.round() ?? 0,
                            double.tryParse(entry['mbleft'])?.round() ?? 0,
                            entry['status'] ?? 'Unknown Status',
                            entry['timeleft'] ?? 'Unknown Time Left',
                            entry['cat'] ?? 'Unknown Category',
                        ));
                    }
                    return [
                        status,
                        queue,
                    ];
                }
            } else {
                logError('getStatusAndQueue', '<GET> HTTP Status Code (${response.statusCode})', null);
            }
        } catch (e) {
            logError('getStatusAndQueue', 'Failed to fetch status and queue', e);
            return null;
        }
        logWarning('getStatusAndQueue', 'Failed to fetch status and queue');
        return null;
    }

    Future<List<SABnzbdHistoryEntry>> getHistory() async {
        try {
            String uri = '$host/api?mode=history&limit=200&output=json&apikey=$key';
            http.Response response = await http.get(
                Uri.encodeFull(uri),
            );
            if(response.statusCode == 200) {
                Map body = json.decode(response.body);
                if(body['status'] == null || body['status']) {
                    List<SABnzbdHistoryEntry> entries = [];
                    for(var entry in body['history']['slots']) {
                        entries.add(SABnzbdHistoryEntry(
                            entry['nzo_id'] ?? '',
                            entry['name'] ?? '',
                            entry['bytes'] ?? 0,
                            entry['status'] ?? '',
                            entry['fail_message'] ?? '',
                            entry['completed'] ?? 0,
                            entry['action_line'] ?? '',
                            entry['category'] == '*' ? 'Default' : entry['category'],
                            entry['download_time'] ?? 0,
                            entry['stage_log'] ?? [],
                            entry['storage'] ?? '',
                        ));
                    }
                    return entries;
                }
            } else {
                logError('getHistory', '<GET> HTTP Status Code (${response.statusCode})', null);
            }
        } catch (e) {
            logError('getHistory', 'Failed to fetch history', e);
            return null;
        }
        logWarning('getHistory', 'Failed to fetch history');
        return null;
    }

    Future<bool> moveQueue(String nzoId, int index) async {
        try {
            String uri = '$host/api?mode=switch&value=$nzoId&value2=$index&output=json&apikey=$key';
            http.Response response = await http.get(
                Uri.encodeFull(uri),
            );
            if(response.statusCode == 200) {
                Map body = json.decode(response.body);
                if(body['status'] == null || body['status']) {
                    if(body.containsKey('result')) {
                        return true;
                    }
                }
            } else {
                logError('moveQueue', '<GET> HTTP Status Code (${response.statusCode})', null);
            }
        } catch (e) {
            logError('moveQueue', 'Failed to move queue entry ($nzoId, $index)', e);
            return false;
        }
        logWarning('moveQueue', 'Failed to move queue entry ($nzoId, $index)');
        return false;
    }

    Future<bool> sortQueue(String sort, String dir) async {
        try {
            String uri = '$host/api?mode=queue&name=sort&sort=$sort&dir=$dir&output=json&apikey=$key';
            http.Response response = await http.get(
                Uri.encodeFull(uri),
            );
            if(response.statusCode == 200) {
                Map body = json.decode(response.body);
                if(body['status'] != null && body['status']) {
                    return true;
                }
            } else {
                logError('sortQueue', '<GET> HTTP Status Code (${response.statusCode})', null);
            }
        } catch (e) {
            logError('sortQueue', 'Failed to sort queue ($sort, $dir)', e);
            return false;
        }
        logWarning('sortQueue', 'Failed to sort queue ($sort, $dir)');
        return false;
    }

    Future<List<SABnzbdCategoryEntry>> getCategories() async {
        try {
            String uri = '$host/api?mode=get_cats&output=json&apikey=$key';
            http.Response response = await http.get(
                Uri.encodeFull(uri),
            );
            if(response.statusCode == 200) {
                Map body = json.decode(response.body);
                if(body['status'] == null || body['status']) {
                    List<SABnzbdCategoryEntry> entries = [];
                    for(var entry in body['categories']) {
                        entries.add(SABnzbdCategoryEntry(
                            entry == '*' ? 'Default': entry,
                        ));
                    }
                    return entries;
                }
            } else {
                logError('getCategories', '<GET> HTTP Status Code (${response.statusCode})', null);
            }
        } catch (e) {
            logError('getCategories', 'Failed to fetch categories', e);
            return null;
        }
        logWarning('getCategories', 'Failed to fetch categories');
        return null;
    }

    Future<bool> setCategory(String nzoId, String category) async {
        try {
            String uri = '$host/api?mode=change_cat&value=$nzoId&value2=$category&output=json&apikey=$key';
            http.Response response = await http.get(
                Uri.encodeFull(uri),
            );
            if(response.statusCode == 200) {
                Map body = json.decode(response.body);
                if(body['status'] != null && body['status']) {
                    return true;
                }
            } else {
                logError('setCategory', '<GET> HTTP Status Code (${response.statusCode})', null);
            }
        } catch (e) {
            logError('setCategory', 'Failed to set category ($nzoId, $category)', e);
            return false;
        }
        logWarning('setCategory', 'Failed to set category ($nzoId, $category)');
        return false;
    }

    Future<bool> setSpeedLimit(int limit) async {
        try {
            String uri = '$host/api?mode=config&name=speedlimit&value=$limit&output=json&apikey=$key';
            http.Response response = await http.get(
                Uri.encodeFull(uri),
            );
            if(response.statusCode == 200) {
                Map body = json.decode(response.body);
                if(body['status'] != null && body['status']) {
                    return true;
                }
            } else {
                logError('setSpeedLimit', '<GET> HTTP Status Code (${response.statusCode})', null);
            }
        } catch (e) {
            logError('setSpeedLimit', 'Failed to set speed limit ($limit)', e);
            return false;
        }
        logWarning('setSpeedLimit', 'Failed to set speed limit ($limit)');
        return false;
    }

    Future<bool> uploadURL(String url) async {
        try {
            String urlEncoded = Uri.encodeComponent(url);
            String uri = '$host/api?mode=addurl&output=json&apikey=$key';
            http.Response response = await http.get(
                Uri.encodeFull(uri) + '&name=$urlEncoded',  
            );
            if(response.statusCode == 200) {
                Map body = json.decode(response.body);
                if(body['status'] != null && body['status']) {
                    return true;
                }
            } else {
                logError('uploadURL', '<GET> HTTP Status Code (${response.statusCode})', null);
            }
        } catch (e) {
            logError('uploadURL', 'Failed to upload NZB by URL ($url)', e);
            return false;
        }
        logWarning('uploadURL', 'Failed to upload NZB by URL ($url)');
        return false;
    }

    Future<bool> uploadFile(String data, String name) async {
        try {
            http.MultipartRequest request = http.MultipartRequest("POST", Uri.parse('$host/api?mode=addfile&output=json&apikey=$key'));
            request.files.add(http.MultipartFile.fromString('name', data, filename: name));
            http.StreamedResponse response = await request.send();
            if(response.statusCode == 200) {
                Map body = json.decode(await response.stream.bytesToString()) ?? {};
                if(body['status'] != null && body['status']) {
                    return true;
                }
            } else {
                logError('uploadFile', '<GET> HTTP Status Code (${response.statusCode})', null);
            }
        } catch (e) {
            logError('uploadFile', 'Failed to upload nzb file ($name)', e);
            return false;
        }
        logWarning('uploadFile', 'Failed to upload nzb file ($name)');
        return false;
    }

    Future<bool> setOnCompleteAction(String action) async {
        try {
            String uri = '$host/api?mode=queue&name=change_complete_action&value=$action&output=json&apikey=$key';
            http.Response response = await http.get(
                Uri.encodeFull(uri),
            );
            if(response.statusCode == 200) {
                Map body = json.decode(response.body);
                if(body['status'] != null && body['status']) {
                    return true;
                }
            } else {
                logError('setOnCompleteAction', '<GET> HTTP Status Code (${response.statusCode})', null);
            }
        } catch (e) {
            logError('setOnCompleteAction', 'Failed to set on-complete action ($action)', e);
            return false;
        }
        logWarning('setOnCompleteAction', 'Failed to set on-complete action ($action)');
        return false;
    }

    Future<bool> clearHistory(String action) async {
        try {
            String uri = '$host/api?mode=history&name=delete&value=$action&output=json&apikey=$key';
            http.Response response = await http.get(
                Uri.encodeFull(uri),
            );
            if(response.statusCode == 200) {
                Map body = json.decode(response.body);
                if(body['status'] != null && body['status']) {
                    return true;
                }
            } else {
                logError('clearHistory', '<GET> HTTP Status Code (${response.statusCode})', null);
            }
        } catch (e) {
            logError('clearHistory', 'Failed to clear history ($action)', e);
            return false;
        }
        logWarning('clearHistory', 'Failed to clear history ($action)');
        return false;
    }

    Future<bool> retryFailedJob(String nzoId) async {
        try {
            String uri = '$host/api?mode=retry&value=$nzoId&output=json&apikey=$key';
            http.Response response = await http.get(
                Uri.encodeFull(uri),
            );
            if(response.statusCode == 200) {
                Map body = json.decode(response.body);
                if(body['status'] != null && body['status']) {
                    return true;
                }
            } else {
                logError('retryFailedJob', '<GET> HTTP Status Code (${response.statusCode})', null);
            }
        } catch (e) {
            logError('retryFailedJob', 'Failed to retry job ($nzoId)', e);
            return false;
        }
        logWarning('retryFailedJob', 'Failed to retry job ($nzoId)');
        return false;
    }

    Future<bool> retryFailedJobPassword(String nzoId, String password) async {
        try {
            String uri = '$host/api?mode=retry&value=$nzoId&password=$password&output=json&apikey=$key';
            http.Response response = await http.get(
                Uri.encodeFull(uri),
            );
            if(response.statusCode == 200) {
                Map body = json.decode(response.body);
                if(body['status'] != null && body['status']) {
                    return true;
                }
            } else {
                logError('retryFailedJobPassword', '<GET> HTTP Status Code (${response.statusCode})', null);
            }
        } catch (e) {
            logError('retryFailedJobPassword', 'Failed to retry job with new password ($nzoId, $password)', e);
            return false;
        }
        logWarning('retryFailedJobPassword', 'Failed to retry job with new password ($nzoId, $password)');
        return false;
    }
}
