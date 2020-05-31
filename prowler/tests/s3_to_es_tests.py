import unittest

from lambdas.s3_to_es import *


class s3ToEs_tests(unittest.TestCase):

    def test_parse_instances(self):

        response_dummy = {
                'Reservations': [
                    {
                        'Instances': [
                            {
                                'InstanceId': 1,
                                'Foo': 'Bar'
                            },
                            {
                                'InstanceId': 2,
                                'Foo': 'Bar'
                            },
                        ]
                    }
                ]
            }

        expected = [1, 2]

        result = parse_instances(response_dummy)
        self.assertEqual(result, expected)
